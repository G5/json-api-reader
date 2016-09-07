module JsonApiReader
  class PageResult
    def initialize(result_hash)
      @result_hash = result_hash
    end

    def attributes
      @attributes ||= data.collect { |data_att| data_att['attributes'] }
    end

    def attributes_by_type(the_type)
      attributes.select do |att|
        the_type == att['type']
      end
    end

    def next_url
      links['next']
    end

    def self_url
      links['self']
    end

    [:data, :meta, :links].each do |method|
      define_method(method) do
        @result_hash[method.to_s]
      end
    end
  end
end