module RuleInterface
  module RuleExecutor
    def execute!(data_hash:, container:, package:, namespace: nil, session: 'session')
      payload = Converter.hash_to_drool(data_hash: data_hash, namespace: namespace, package: package, session: session)
      response = parsed_connection!(container: container, method: "post", payload: payload)
      if response[:type] && response[:type] == "SUCCESS"
        Converter.drool_to_hash(
          response_data: response[:result][:'execution-results'][:results]
        )
      else
        raise Error::CommonError, response[:msg]
      end
    end

    private

    def parsed_connection!(*args)
      JSON.parse(connection!(*args), symbolize_names: true)
    end

    def connection!(container:, method: :get, payload: {})
      kieserver_config = Configuration.kiesever_config
      rc = RestClient::Resource.new(
          kieserver_url(kieserver_config: kieserver_config, container: container),
          kieserver_config[:username],
          kieserver_config[:password]
        )

      case method
      when :get
        rc.get(accept: :json)
      else
        rc.send(method.to_sym, payload.to_json, 'Content-Type' => 'application/json')
      end
    end

    def kieserver_url(kieserver_config:, container:)
      "#{kieserver_config[:hostname]}/kie-server/services/rest/server/containers/instances/#{container}"
    end
  end
end
