module JsonApiReader
  class Reader
    def initialize(options={}, block)
      raise ArgumentError.new("'endpoint' option is required") if options[:endpoint].nil?
      @url     = options[:endpoint]
      @options = options.clone
      @block   = block
    end

    def all_pages
      while !@url.nil?
        @url = fetch.next_url
      end
    end

    def fetch
      result = JsonApiReader::Fetcher.fetch_all(@url, @options)
      @block.call(result)
      result
    end

    class << self
      def all_pages(options={}, &block)
        new(options, block).all_pages
      end

      def first_page(options={}, &block)
        new(options, block).fetch
      end
    end
  end
end