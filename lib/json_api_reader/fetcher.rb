module JsonApiReader
  class Fetcher
    class << self
      def fetch_all(url, options={})
        response = get url, options
        raise JsonApiReader::RecordNotFoundError.new("404 - URL: '#{url}'") if 404 == response.code
        JsonApiReader::PageResult.new JSON.parse(response.body)
      end

      def get(url, options={})
        query = options[:query]

        if options[:token_retriever_proc]
          options[:token_retriever_proc].call do |token|
            HTTParty.get(url,
                         query:   query,
                         headers: {'Content-Type'  => 'application/json',
                                   'Accept'        => 'application/json',
                                   'Authorization' => "Bearer #{token}"})
          end
        else
          HTTParty.get(url,
                       query:   query,
                       headers: {'Content-Type' => 'application/json',
                                 'Accept'       => 'application/json'})
        end
      end
    end
  end
end