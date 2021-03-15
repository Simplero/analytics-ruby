require 'twilio_segment/analytics/version'
require 'twilio_segment/analytics/defaults'
require 'twilio_segment/analytics/utils'
require 'twilio_segment/analytics/field_parser'
require 'twilio_segment/analytics/client'
require 'twilio_segment/analytics/worker'
require 'twilio_segment/analytics/transport'
require 'twilio_segment/analytics/response'
require 'twilio_segment/analytics/logging'

module TwilioSegment
  class Analytics
    # Initializes a new instance of {TwilioSegment::Analytics::Client}, to which all
    # method calls are proxied.
    #
    # @param options includes options that are passed down to
    #   {TwilioSegment::Analytics::Client#initialize}
    # @option options [Boolean] :stub (false) If true, requests don't hit the
    #   server and are stubbed to be successful.
    def initialize(options = {})
      Transport.stub = options[:stub] if options.has_key?(:stub)
      @client = TwilioSegment::Analytics::Client.new options
    end

    def method_missing(message, *args, &block)
      if @client.respond_to? message
        @client.send message, *args, &block
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @client.respond_to?(method_name) || super
    end

    include Logging
  end
end
