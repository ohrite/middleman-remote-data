require "faraday"
require "faraday_middleware"

module Middleman::Features::RemoteData
  class << self
    def registered(app)
      app.extend ClassMethods
    end
    alias :included :registered
  end
  
  module ClassMethods
    # Makes HTTP json data available in the data object
    #
    #     data_source :my_json, "http://my/file.json"
    #
    # Available in templates as:
    #
    #     data.my_json
    def data_source(name, url)
      connection = Faraday.new do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Adapter::NetHttp
        builder.use FaradayMiddleware::ParseXml,  :content_type => /\bxml$/
        builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      end
      
      data_callback(name) do
        connection.get(url).body
      end
    end
  end
end