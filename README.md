#ActivePubsub Examples

First, make sure you have rabbitmq running on the default port (5672)
If you are running rabbit at different address or port, set address via ENV variable, i.e.

```
RABBITMQ_URL=amqp://guest:guest@x.x.x.x:XXXX bundle exec subscriber start
```

### Clone it

```
git clone git@github.com:jasonayre/active_pubsub_examples.git
```

### Setup ecom service (publisher example)
```
cd ecom && bundle && rake db:create db:migrate

```

### Setup data warehouse (subscriber example)
In new window:

```
cd data_warehouse && bundle && rake db:create db:migrate
```

### Start data warehouse subscriber

```
bundle exec subscriber start
```

### Start creating fake sales in ecom service

```
rake db:seed
```
