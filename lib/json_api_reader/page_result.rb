module JsonApiReader
  class PageResult
    def initialize(result_hash)
      @result_hash = result_hash
    end

    def attributes
      @attributes ||= data.collect { |data_att| data_att['attributes'] }
    end

    def data_by_type(the_type)
      data.select do |data_element|
        the_type.to_s == data_element['type']
      end
    end

    def data_by_type_and_id(the_type, the_id)
      data.detect do |data_element|
        the_type.to_s == data_element['type'] && the_id.to_s == data_element['id'].to_s
      end
    end

    def attributes_by_type(the_type)
      data_by_type(the_type).collect do |data_element|
        data_element['attributes']
      end
    end

    def attributes_by_type_and_id(the_type, the_id)
      data_by_type_and_id(the_type, the_id)['attributes']
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