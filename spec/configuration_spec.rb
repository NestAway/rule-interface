require 'spec_helper'

RSpec.describe RuleInterface::Configuration do

  klass = RuleInterface::Configuration

  before(:all) do
    klass.kiesever_config = nil
  end

  it 'should allow to set and get restforce_config' do
    config = {test: :ok}
    klass.kiesever_config = config
    expect(klass.kiesever_config).to eq(config)
    klass.kiesever_config = nil
  end
end
