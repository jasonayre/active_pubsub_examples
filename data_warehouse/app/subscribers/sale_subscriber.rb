class SaleSubscriber < ::ActivePubsub::Subscriber
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

  on :created do |record|
    puts record.inspect
    sales_report = ::ProductSalesReport.where(:product_id => record["product_id"]).first_or_create
    sales_report.total_sales ||= 0
    sales_report.total_sales += record["price"]
    sales_report.save

    puts sales_report.inspect

    puts "Total Sales After Update: #{sales_report.total_sales}"
  end

  #for example if we refunded our customers by destroying sales receipts records
  #which would of course be an excellent business practice
  on :destroyed do |record|
    sales_report = ::ProductSalesReport.find_by(:product_id => record["product_id"])

    if(sales_report)
      sales_report.total_sales -= record["price"]
      sales_report.save
    end

    puts "Total Sales After Destroy: #{sales_report.total_sales}"
  end

  # including active model dirty and including changed attributes in serialization
  # so you can see what attributes have changed.
  on :updated do |record|
    sales_report = ::ProductSalesReport.find_by(:product_id => record["product_id"])

    if(sales_report)
      price_change = record["changes"]["price"][0] - record["changes"]["price"][1]
      sales_report.total_sales += record["price"]
      sales_report.save
    end

    puts "Total Sales After Update: #{sales_report.total_sales}"
  end
end
