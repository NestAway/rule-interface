require 'spec_helper'

RSpec.describe RuleInterface::Configuration do

  klass = RuleInterface::Configuration

  before(:all) do
    @config = {
      username: 'blah',
      password: 'blah',
      hostname: 'http://url'
    }
  end

  before(:each) do
    klass.kiesever_config = nil
    clear_env
  end

  def set_env
    ENV['KIE_SERVER_USERNAME'] = @config[:username]
    ENV['KIE_SERVER_PASSWORD'] = @config[:password]
    ENV['KIE_SERVER_HOSTNAME'] = @config[:hostname]
  end

  def clear_env
    ENV['KIE_SERVER_USERNAME'] = nil
    ENV['KIE_SERVER_PASSWORD'] = nil
    ENV['KIE_SERVER_HOSTNAME'] = nil
  end

  it 'should allow to set and set kiesever_config' do
    klass.kiesever_config = @config
    expect(klass.kiesever_config).to eq(@config)
  end

  it 'should take value from ENV if spefied' do
    set_env
    expect(klass.kiesever_config).to eq(@config)
  end

  it 'ENV should not overwrite specified custom config with ENV' do
    set_env
    patch_config = {username: 'test'}
    klass.kiesever_config = patch_config
    expect(klass.kiesever_config).to eq(@config.merge(patch_config))
  end

  it 'should through an ConfigError if KIE username is missing' do
    expect { klass.kiesever_config }.to raise_error(RuleInterface::Error::ConfigError, 'KIE server username missing')
  end

  it 'should through an ConfigError if KIE password is missing' do
    ENV['KIE_SERVER_USERNAME'] = @config[:username]
    expect { klass.kiesever_config }.to raise_error(RuleInterface::Error::ConfigError, 'KIE server password missing')
  end

  it 'should through an ConfigError if KIE hostname is missing' do
    ENV['KIE_SERVER_USERNAME'] = @config[:username]
    ENV['KIE_SERVER_PASSWORD'] = @config[:password]
    expect { klass.kiesever_config }.to raise_error(RuleInterface::Error::ConfigError, 'KIE server hostname missing')
  end
end
