module JsonApiReader
  class PageResult
    include HashKeysHelper
    attr_reader :result_hash

    def initialize(result_hash)
      @result_hash = result_hash
    end

    def convert_dash_keys_to_underscore!
      @attributes = nil
      @result_hash = recursive_convert_dash_keys_to_underscore @result_hash
    end

    def attributes
      @attributes ||= data.collect { |data_att| data_att['attributes'] }
    end

    def included_by_type_and_id(the_type, the_id)
      data_by_type_and_id the_type, the_id, parent: :included
    end

    def data_by_type(the_type, parent: :data)
      send(parent).select do |data_element|
        the_type.to_s == data_element['type']
      end
    end

    def data_by_type_and_id(the_type, the_id, parent: :data)
      send(parent).detect do |data_element|
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

    [:data, :meta, :links, :included].each do |method|
      define_method(method) do
        @result_hash[method.to_s]
      end
    end
  end
end