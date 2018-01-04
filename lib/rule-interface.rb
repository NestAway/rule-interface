require 'active_support/core_ext'
require 'rest-client'

Dir[File.expand_path('rule-interface/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end

module RuleInterface
  extend RuleExecutor
end
