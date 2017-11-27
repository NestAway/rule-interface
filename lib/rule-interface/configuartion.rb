module RuleInterface
  class Configuration

    class << self

      #ex - {:username=>"kieserver", :password=>"kieserver1!", :hostname=>"http://rule-engine-..."}
      def kiesever_config=(config)
        @kiesever_config = config
      end

      def kiesever_config
        unless defined? @kiesever_config && @kiesever_config.present?
          raise Error::CommonError, "Configuration for rule engine is not yet set"
        end
        @kiesever_config
      end

    end
  end
end
