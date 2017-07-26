module HashKeysHelper
  def recursive_convert_dash_keys_to_underscore(hash)
    {}.tap do |h|
      hash.each do |key, value|
        new_key    = key.gsub('-', '_')
        h[new_key] = map_value(value)
      end
    end
  end

  def map_value(thing)
    case thing
      when Hash
        recursive_convert_dash_keys_to_underscore(thing)
      when Array
        thing.map { |v| map_value(v) }
      else
        thing
    end
  end
end