module RuleInterface
  module Converter
    extend self

    def hash_to_drool(data_hash:, namespace:, package:)
      payload = {}
      payload[:lookup] = 'session'
      payload[:commands] = []

      #insert namespace object
      payload[:commands] << insert_object(
        data_object: {
          name: namespace
        },
        object_type: 'namespace',
        package: package,
        return_object: false
      )

      data_hash.each do |object_type, data_objects|
        data_objects.each do |data_object|
          payload[:commands] << insert_object(
            data_object: data_object,
            object_type: object_type,
            package: package
          )
        end
      end
      payload
    end

    def drool_to_hash(response_data:)
      result_hash = Hash.new {|h,k| h[k] = [] }
      response_data.each do |data|
        object_type = data[:value].keys[0].to_s.split('.').last.underscore.to_sym

        data_object = data[:value][data[:value].keys[0]]
        data_object = data_object.inject({}) { |m, (k,v)| m[k.to_s.underscore.to_sym] = v; m }

        result_hash[object_type] << data_object
      end
      result_hash
    end

    private

    def insert_object(data_object:, object_type:, package:, return_object: true)
      if return_object && data_object[:id].blank?
        raise Error::CommonError, "Object must have an id attribute: #{data_object.to_json}"
      end

      data_object = data_object.inject({}) do |m, (k,v)|
        m[k.to_s.camelize(:lower).to_sym] = v; m
      end

      object_type = object_type.to_s.camelize.to_sym
      insert_object = {}
      insert_object[:insert] = {}
      insert_object[:insert]['return-object'] = return_object
      insert_object[:insert]['out-identifier'] = "#{object_type}##{data_object[:id]}" if return_object

      object = {}
      object_name = "#{package}.#{object_type}"
      object[object_name] = data_object

      insert_object[:insert][:object] = object
      insert_object
    end

  end
end
