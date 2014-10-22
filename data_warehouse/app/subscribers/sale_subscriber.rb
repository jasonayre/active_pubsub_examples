class SaleSubscriber < ::ActivePubsub::Subscriber

  class_attribute :message_count
  self.message_count = 0
  #the exchange you are observing, i.e. service_name.resource_type
  observes "ecom.sale"

  #the local service name to prefix to the queue
  #necessary to identify the individual services which watch a particular event
  #i.e. one copy of any message will be delivered ONCE to each service interested,
  #and whether that service is running 1 or 10000 subscriber processes, it will get
  #exactly one copy of the message
  as "data_warehouse"

  #in this example we are pretending that we have a ProductSalesReport
  #which keeps track of all sales of a particular record

  # Note --
  # This example does not pass record in as block
  # each subscriber is initialized with a copy of record as well
  # So you can choose to access it via block or the method
  # this is so you can keep your subscribers more resourceful,
  # in the event you are doing something with the record at the beginning of
  # every method call
  on :created do
    self.class.message_count += 1

    current_sales_report.total_sales ||= 0
    current_sales_report.total_sales += record[:price]
    current_sales_report.save

    puts "Total Sales After Update: #{current_sales_report.total_sales}"
    puts "Messages Processed: #{self.class.message_count}"
  end

  #for example if we refunded our customers by destroying sales receipts records
  #which would of course be an excellent business practice
  on :destroyed do |destroyed_record|
    sales_report = ::ProductSalesReport.find_by(:product_id => destroyed_record[:product_id])

    if(sales_report)
      sales_report.total_sales -= destroyed_record[:price]
      sales_report.save
    end

    puts "Total Sales After Destroy: #{sales_report.total_sales}"
  end

  # including active model dirty and including changed attributes in serialization
  # so you can see what attributes have changed.
  on :updated do |updated_record|
    sales_report = ::ProductSalesReport.find_by(:product_id => updated_record["product_id"])

    if(sales_report)
      price_change = updated_record[:changes]["price"][0] - updated_record[:changes]["price"][1]
      sales_report.total_sales += updated_record[:price]
      sales_report.save
    end

    puts "Total Sales After Update: #{sales_report.total_sales}"
  end

  def current_sales_report
    @current_sales_report ||= ::ProductSalesReport.where(:product_id => record[:product_id]).first_or_create
  end

end
