require "httparty"

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
      data_callback(name) do
        HTTParty.get(url).parsed_response
      end
    end
  end
end