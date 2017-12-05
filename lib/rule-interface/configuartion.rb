module RuleInterface
  class Configuration

    class << self

      # eg: {
      #     username: 'blah',
      #     password: 'blah',
      #     hostname: 'http://url'
      #}
      def kiesever_config=(config)
        @cached = false
        @kiesever_config = config
      end

      def kiesever_config
        return @kiesever_config if @cached

        @kiesever_config ||= {}

        @kiesever_config[:username] ||= ENV['KIE_SERVER_USERNAME'].presence
        @kiesever_config[:password] ||= ENV['KIE_SERVER_PASSWORD'].presence
        @kiesever_config[:hostname] ||= ENV['KIE_SERVER_HOSTNAME'].presence

        raise Error::ConfigError, 'KIE server username missing' if @kiesever_config[:username].blank?
        raise Error::ConfigError, 'KIE server password missing' if @kiesever_config[:password].blank?
        raise Error::ConfigError, 'KIE server hostname missing' if @kiesever_config[:hostname].blank?

        @cached = true

        @kiesever_config
      end

    end
  end
end
