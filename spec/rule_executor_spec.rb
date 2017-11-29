require 'spec_helper'

RSpec.describe RuleInterface do

  before(:all) do
    @namespace = 'namespace'
    @package = 'package'
    @container = 'container'

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
            name: 'blah'
          }
        ]
      }
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
                  :"#{@package}.Namespace" => {:name => @namespace}
                }
              }
            },
            {
              insert: {
                :'return-object' => true,
                :'out-identifier' => "User_#{@user_id}",
                object: {
                  :"#{@package}.User" => data_hash[:user][0]
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
                    :"#{@package}.User" => data_hash[:user][0]
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

    it 'should raise and error' do
      data_hash = {
        user: [
          {
            id: @user_id,
            name: 'blah'
          }
        ]
      }

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
                  :"#{@package}.Namespace" => {
                    name: @namespace
                  }
                }
              }
            },
            {
              insert: {
                :'return-object' => true,
                :'out-identifier' => "User_#{@user_id}",
                object: {
                  :"#{@package}.User" => data_hash[:user][0]
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
  end

end
