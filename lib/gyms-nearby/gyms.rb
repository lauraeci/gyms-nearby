require 'faraday'

module GymsNearby
  class Gyms

    class Response < SimpleDelegator
      def code
        __getobj__.status
      end

      def header
        __getobj__.headers
      end
    end

    class NormalizeParams < Faraday::Middleware
      def call(env)
        env.params = normalize(env.params)
        env.body = normalize(env.body)
        @app.call(env)
      end

      def normalize(param)
        case param
        when Array
          fix_arrays(param)
        when Hash
          new_hash = {}
          param.each do |k, v|
            new_hash[k] = normalize(v)
          end
          new_hash
        else
          if param.respond_to?(:path) && param.respond_to?(:read)
            Faraday::UploadIO.new(param.path, mime_for(param.path))
          else
            param
          end
        end
      end

      private

      def mime_for(path)
        mime = MIME::Types.type_for(path)
        mime.empty? ? 'text/plain' : mime[0].content_type
      end

      def fix_arrays(arrays)
        if arrays.size == 0
          [nil]
        else
          arrays.collect do |v|
            normalize(v)
          end
        end
      end

    end

    attr_accessor :lat, :long, :radius, :config

    def initialize(lat, long, **config)
      @lat = lat
      @long = long
      @config = config
      @url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
      set_connection
    end

    def within_radius(radius:, api_key:, type:)
      config = {
        default_headers: {'Content-Type' => 'application/json'},
        default_params: {'key' => api_key}
      }
      params = {
        "location" => "#{@lat},#{@long}",
        "type" => type || "gym",
        "radius" => radius,
        "key" => api_key
      }
      get(params: params, **config)
    end

    private

    def full_path(path)
      url = URI.parse("#{@url.to_s}#{path}")
      append_default_params(url.to_s)
    end

    def append_default_params(path)
      uri = URI(path)
      params = URI.decode_www_form(uri.query || '') + default_params.to_a
      uri.query = URI.encode_www_form(params)
      uri.query = nil if uri.query == ''
      uri.to_s
    end

    def set_connection
      # https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&type=restaurant&keyword=cruise&key=YOUR_API_KEY
      @connection = Faraday.new(:url => @url) do |faraday|
        # this is configured with middleware. order matters
        faraday.ssl.verify = false
        faraday.use NormalizeParams
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter :net_http_persistent
      end
    end

    def get(params: nil, headers: nil, **args)
      request(method: :get, params: params, headers: headers, **args)
    end

    def request(method:, params: nil, body: nil, headers: nil, **args)
      headers ||= {}
      if args.has_key?(:default_headers)
        default_headers = args[:default_headers]
      end
      headers.merge!(default_headers)

      params = @default_params.merge(params || {}) if [:post, :put, :delete].include?(method)

      response = @connection.run_request(method, @url, body, headers) do |request|
        request.params.update(params) if params && !params.empty?
      end
      Response.new(response)
    rescue Faraday::ClientError => e
      raise Error.new(e)
    end
  end
end
