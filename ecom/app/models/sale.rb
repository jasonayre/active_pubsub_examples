class Sale < ActiveRecord::Base
  include ActivePubsub::Publishable

  publish_as "ecom"

  belongs_to :customer
  belongs_to :product
end
