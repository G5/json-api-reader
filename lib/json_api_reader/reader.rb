module JsonApiReader
  class Reader
    class << self
      def paginate_all(options={}, &block)

      end

      def first_page(options={}, &block)
        result = JsonApiReader::Fetcher.fetch_all(options[:endpoint], options)
        block.call result
      end
    end
  end
end