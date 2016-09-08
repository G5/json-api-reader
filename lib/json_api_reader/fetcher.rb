module JsonApiReader
  class Fetcher
    def initialize(url, options={})
      @url     = url
      @options = options
    end

    class << self
      def fetch_all(url, options={})
        new(url, options).fetch_all
      end
    end

    def fetch_all
      response = HTTParty.get(@url, query: query, headers: headers)

      raise JsonApiReader::RecordNotFoundError.new("404 - URL: '#{@url}'") if 404 == response.code
      raise JsonApiReader::NotAuthorizedError.new("401 - URL: '#{@url}'") if 401 == response.code
      raise JsonApiReader::Error.new("#{response.code} returned from URL: '#{@url}'") if response.code >= 400
      JsonApiReader::PageResult.new JSON.parse(response.body)
    end

    def headers
      {'Content-Type' => 'application/json',
       'Accept'       => 'application/json'}.
          merge(@options[:headers] || {})
    end

    def query
      @options[:query]
    end
  end
end