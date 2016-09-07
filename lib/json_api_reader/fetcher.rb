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
      response = get
      raise JsonApiReader::RecordNotFoundError.new("404 - URL: '#{@url}'") if 404 == response.code
      JsonApiReader::PageResult.new JSON.parse(response.body)
    end

    def get
      if token_retriever?
        @options[:token_retriever_class].send(@options[:token_retriever_method]) do |token|
          execute_get(query:   query,
                      headers: headers(token))
        end
      else
        execute_get(query:   query,
                    headers: headers)
      end
    end

    def execute_get(params)
      HTTParty.get(@url, params)
    end

    def headers(token=nil)
      the_headers                  = {'Content-Type' => 'application/json',
                                      'Accept'       => 'application/json'}
      the_headers['Authorization'] = "Bearer #{token}" unless token.nil?
      the_headers
    end

    def token_retriever?
      @options[:token_retriever_class] && @options[:token_retriever_method]
    end

    def query
      @options[:query]
    end
  end
end