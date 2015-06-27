module BatchedQuery
  class Runner
    DEFAULT_LIMIT = 500

    def self.limit=(limit)
      @limit = limit
    end

    def self.limit
      @limit || DEFAULT_LIMIT
    end

    def self.each_set(query, &block)
      cached_ids = get_ordered_list_of_ids(query)

      cached_ids.each_slice(limit).each do |batch_of_ids|
        results = query.where(:id => batch_of_ids)
        block.call results
      end
    end

    def self.each_result(query, &block)
      each_set(query) do |set|
        set.each do |result|
          block.call result
        end
      end
    end

    private

    def self.get_ordered_list_of_ids(query)
      query.pluck(:id)
    end
  end
end
