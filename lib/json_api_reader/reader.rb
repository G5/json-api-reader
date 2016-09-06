module JsonApiReader
  class Reader
    class << self
      def paginate_all(options={}, &block)

      end

      def first_page(options={}, &block)
        raise ArgumentError.new("'endpoint' option is required") if options[:endpoint].nil?
        result = fetch(options[:endpoint], options)
        block.call result
      end

      def fetch(url, options)
        JsonApiReader::Fetcher.fetch_all(url, options)
      end
    end
  end
end