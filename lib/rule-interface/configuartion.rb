module RuleInterface
  class Configuration

    class << self

      #ex - {:username=>"kieserver", :password=>"kieserver1!", :hostname=>"http://rule-engine-..."}
      def kiesever_config=(config)
        @cached = false
        @kiesever_config = config
      end

      def kiesever_config
        return @kiesever_config if @cached

        @kiesever_config ||= {}

        @kiesever_config[:username] ||= ENV[:KIE_SERVER_USERNAME].presence
        @kiesever_config[:password] ||= ENV[:KIE_SERVER_PASSWORD].presence
        @kiesever_config[:hostname] ||= ENV[:KIE_SERVER_HOSTNAME].presence

        if @kiesever_config.values.compact!.blank?
          raise Error::CommonError, 'Configuration for rule engine is not set'
        end

        @cached = true

        @kiesever_config
      end

    end
  end
end
