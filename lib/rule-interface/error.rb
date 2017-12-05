module RuleInterface
  module Error
    # A general exception
    class Base < StandardError; end

    class CommonError < Base; end

    class ConfigError < Base; end
  end
end
