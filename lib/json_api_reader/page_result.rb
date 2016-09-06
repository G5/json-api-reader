module JsonApiReader
  class PageResult
    def initialize(result_hash)
      @result_hash = result_hash
    end

    def attributes
      @attributes ||= @result_hash.fetch('data', []).collect { |data_att| data_att['attributes'] }
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

    def meta
      @result_hash.fetch('meta', {})
    end

    def links
      @result_hash.fetch('links', {})
    end
  end
end