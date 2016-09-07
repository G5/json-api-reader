module JsonApiReader
  class Fetcher
    class << self
      def fetch_all(url, options={})
        response = get url, options
        raise JsonApiReader::RecordNotFoundError.new("404 - URL: '#{url}'") if 404 == response.code
        JsonApiReader::PageResult.new JSON.parse(response.body)
      end

      def get(url, options={})
        headers = {'Content-Type' => 'application/json',
                   'Accept'       => 'application/json'}.merge(options.fetch(:headers, {}))
        
        HTTParty.get(url,
                     query:   options[:query],
                     headers: headers)
      end
    end
  end
end