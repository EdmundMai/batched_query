# BatchedQuery

A memory saving alternative to `Active::Record`'s `find_in_batches` and `find_each` methods that spreads queries with large result sets into smaller manageable subsets while allowing you to set a sort order. This saves an enormous amount of memory / RAM when handling large queries (1000+), especially those that can grow over time.

## Installation

Add this line to your application's Gemfile:

    gem 'batched_query'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install batched_query

## Usage

You may either loop through ActiveRecord results using `BatchedQuery::Runner.each_set(query, &block)` like so:

    # Any ActiveRecord query
    cars = Car.where("brand_name = 'Ferrari'")order("created_at desc")

    # Set the limit of each subquery
    BatchedQuery::Runner.limit = 100
    BatchedQuery::Runner.each_set(cars) do |batch_of_cars|
      # process results in manageable subsets
      batch_of_cars.map { |car| ... }
    end
    
Or you may loop through all the results using `BatchedQuery::Runner.each_result(query, &block)` like so:

    BatchedQuery::Runner.limit = 200
    BatchedQuery::Runner.each_result(cars) do |car|
      # access each car as if you loaded all of the records at once
      car.start!
    end

By default, if you don't set the limit explicitly, it will default to 500 results per query.

Note: If you are using any `includes(...)` methods the total amount of objects loaded will double and the limit that you set will only apply to the model you are running a query on.

One limitation of this implementation is that you will not be able to use "select" or "pluck" statements in your query. However, those statements generally take a lot less memory because you are loading an array of strings / integers instead of full ActiveRecord objects.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/batched_query/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
