require 'skink'
require 'skink/client/base'
require 'skink/rack_test_client/rack_test_client'
require 'skink/resourceful_client/resourceful_client'

module Skink
  class << self
    attr_writer :rack_app
    attr_accessor :base_url

    def rack_app
      raise ConfigurationError.new "You must set Skink.rack_app to use the DSL." unless @rack_app
      @rack_app
    end

    def client
      @client ||= new_client
    end

    def new_client
      if base_url.nil? || base_url.empty?
        RackTestClient.new(rack_app)
      else
        ResourcefulClient.new(base_url)
      end
    end

    def reset_client!
      @client = nil
    end
  end

  module DSL
    def self.included(base)
      puts "Skink::DSL being included in #{base.inspect}"
    end

    def self.extended(base)
      puts "Skink::DSL extending #{base.inspect}"
    end

    Skink::Client::Base.instance_methods(false).each do |method|
      define_method method do |*args, &block|
        Skink.client.send method, *args, &block
      end
    end
  end

  extend Skink::DSL
end
