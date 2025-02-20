class ProductsWorker
  include Sneakers::Worker
  # This worker will connect to "dashboard.posts" queue
  # env is set to nil since by default the actuall queue name would be
  # "dashboard.posts_development"
  from_queue "doz.product_discount", env: nil, exchange: 'product_discount', exchange_type: 'fanout', durable: false

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to RecentPosts service without
  # changes
  def work(raw_product)
    discount = JSON.parse(raw_product)
    Product.find_by(id: discount['product']).update(discount: discount['discount'])
    ack! # we need to let queue know that message was received
  end
end