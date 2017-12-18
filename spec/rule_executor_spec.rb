require 'spec_helper'

RSpec.describe RuleInterface do

  before(:all) do
    @namespace = 'namespace'
    @package = 'package'
    @container = 'container'
    @session = 'lookup'

    @namespace_obj = {
      name: @namespace
    }

    @user_id = 1

    @kiesever_config = {
      username: 'kieserver',
      password: 'kieserver1!',
      hostname: 'http://test.com'
    }

    RuleInterface::Configuration.kiesever_config = @kiesever_config
  end

  describe 'execute' do
    it 'should execute rule and return response' do
      data_hash = {
        user: [
          {
            id: @user_id,
            name: 'blah',
            something_with_underscore: 'blah'
          }
        ]
      }
      user_obj = data_hash[:user][0].inject({}) do |m, (k,v)|
        m[k.to_s.camelize(:lower).to_sym] = v; m
      end

      stub_request(
        :post,
        "#{@kiesever_config[:hostname]}/kie-server/services/rest/server/containers/instances/#{@container}"
      ).with(
        body: {
          lookup: 'lookup',
          commands: [
            {
              insert: {
                :'return-object' => false,
                object: {
                  :"#{@package}.Namespace" => @namespace_obj
                }
              }
            },
            {
              insert: {
                :'return-object' => true,
                :'out-identifier' => "User##{@user_id}",
                object: {
                  :"#{@package}.User" => user_obj
                }
              }
            }
          ]
        }.to_json
      ).to_return(
        status: 200,
        body: {
          type: 'SUCCESS',
          result: {
            :'execution-results' => {
              results: [
                {
                  value: {
                    :"#{@package}.User" => user_obj
                  }
                }
              ]
            }
          }
        }.to_json,
        headers: {'Content-Type' => 'application/json'}
      )

      result_data = RuleInterface.execute!(
        data_hash: data_hash,
        namespace: @namespace,
        package: @package,
        container: @container,
        session: @session
      )

      expect(result_data).to eq data_hash
    end

    it 'should raise and error' do
      data_hash = {}

      stub_request(
        :post,
        "#{@kiesever_config[:hostname]}/kie-server/services/rest/server/containers/instances/#{@container}"
      ).with(
        body: {
          lookup: 'session',
          commands: [
            {
              insert: {
                :'return-object' => false,
                object: {
                  :"#{@package}.Namespace" => @namespace_obj
                }
              }
            }
          ]
        }.to_json
      ).to_return(
        status: 200,
        body: {
          type: 'FAILURE',
          result: nil,
          msg: 'Error'
        }.to_json,
        headers: {
          'Content-Type' => 'application/json'
        }
      )

      allow(RuleInterface).to receive(:execute!).with(
        data_hash: data_hash,
        namespace: @namespace,
        package: @package,
        container: @container
      ).and_raise(RuleInterface::Error::CommonError, 'Error')
    end

    it 'should take default session name if not provided' do
      data_hash = {
        user: [
          {
            id: @user_id,
            name: 'blah',
            something_with_underscore: 'blah'
          }
        ]
      }
      user_obj = data_hash[:user][0].inject({}) do |m, (k,v)|
        m[k.to_s.camelize(:lower).to_sym] = v; m
      end

      stub_request(
        :post,
        "#{@kiesever_config[:hostname]}/kie-server/services/rest/server/containers/instances/#{@container}"
      ).with(
        body: {
          lookup: 'session',
          commands: [
            {
              insert: {
                :'return-object' => false,
                object: {
                  :"#{@package}.Namespace" => @namespace_obj
                }
              }
            },
            {
              insert: {
                :'return-object' => true,
                :'out-identifier' => "User##{@user_id}",
                object: {
                  :"#{@package}.User" => user_obj
                }
              }
            }
          ]
        }.to_json
      ).to_return(
        status: 200,
        body: {
          type: 'SUCCESS',
          result: {
            :'execution-results' => {
              results: [
                {
                  value: {
                    :"#{@package}.User" => user_obj
                  }
                }
              ]
            }
          }
        }.to_json,
        headers: {'Content-Type' => 'application/json'}
      )

      result_data = RuleInterface.execute!(
        data_hash: data_hash,
        namespace: @namespace,
        package: @package,
        container: @container
      )

      expect(result_data).to eq data_hash
    end
  end

end
