require 'rails_helper'

RSpec.describe RuleInterface::RuleExecution do

  before(:all) do
    @admin = FactoryGirl.create(:user, role_name: 'admin')
    @owner = FactoryGirl.create(:user, role_name: 'owner')
    @house = FactoryGirl.create(:house, owner_id: @owner.profile.id)
    @user1 = FactoryGirl.create(:user, role_name: 'tenant')

    @type = Faker::Lorem.word
    @package = Faker::Lorem.word
    @container = Faker::Lorem.word

    RuleInterface::Configuration.kiesever_config={:username => 'kieserver', :password => 'kieserver1!', :hostname => 'http://kieserver:kieserver1!@test.com'}
    @kiesever_config = RuleInterface::Configuration.kiesever_config
  end

  describe 'execute' do
    it 'should execute rule and return response' do
      data_hash = {:user => [{
        :id => @user1.id,
        :name => Faker::Lorem.word
        }]
      }
      stub_request(:post, "#{@kiesever_config[:hostname]}/kie-server/services/rest/server/containers/instances/#{@container}").
        with(body: {
          :lookup => "session",
          :commands => [{
            :insert => {
              :"return-object" => false,
              :object => {
                :"#{@package}.Namespace" => {:type => @type}
              }
            }
          },{
            :insert => {
              :"return-object" => true,
              :"out-identifier" => "User_#{@user1.id}",
              :object => {
                :"#{@package}.User" => data_hash[:user][0]
              }
            }
          }]
        }.to_json).to_return(status: 200,
            body: { type: "SUCCESS",
                    result: {
                      :"execution-results" => {
                        :results => [{
                        :value => {
                          :"#{@package}.User" => data_hash[:user][0]
                        }
                      }]
                    }
                  }
                }.to_json,
            :headers => {"Content-Type" => "application/json"},
            )

      result_data = RuleInterface::RuleExecution.execute(data_hash: data_hash, type: @type, package: @package, container: @container)

      expect(result_data).to eq data_hash
    end

    it 'should raise and error' do
      data_hash = {:user => [{
        :id => @user1.id,
        :name => Faker::Lorem.word
        }]
      }
      stub_request(:post, "#{@kiesever_config[:hostname]}/kie-server/services/rest/server/containers/instances/#{@container}").
        with(body: {
          :lookup => "session",
          :commands => [{
            :insert => {
              :"return-object" => false,
              :object => {
                :"#{@package}.Namespace" => {:type => @type}
              }
            }
          },{
            :insert => {
              :"return-object" => true,
              :"out-identifier" => "User_#{@user1.id}",
              :object => {
                :"#{@package}.User" => data_hash[:user][0]
              }
            }
          }]
        }.to_json).to_return(status: 200,
            body: { type: "FAILURE",
                    result: nil,
                    msg: 'Error'
                }.to_json,
            :headers => {"Content-Type" => "application/json"},
            )

      allow(RuleInterface::RuleExecution).to receive(:execute).with(data_hash: data_hash, type: @type, package: @package, container: @container).and_raise(RuleInterface::Error::CommonError, 'Error')
    end
  end

end
