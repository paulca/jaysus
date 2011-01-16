module Jaysus
  module Remote
    def self.base_url
      @base_url ||= ''
    end
    
    def self.base_url=(url)
      @base_url = url
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    def destroy
      super do
        RestClient.delete(remote_url,{
          'Accept' => 'application/json'
        })
      end
    end
    
    def save
      super do
        response = if pk = self.send(self.class.model_base.primary_key)
          RestClient.put("#{self.class.model_url}/#{pk}", self.to_json, {
            'Content-Type' => 'application/json'
          })
        else
          RestClient.post(self.class.model_url, self.to_json, {
            'Content-Type' => 'application/json'
          })
        end
        decoded_response = ActiveSupport::JSON.decode(
          response
        )[self.class.singular_name]
        self.set_attributes(decoded_response)
        self
      end
    end
    
    def remote_url
      pk = self.send(self.class.model_base.primary_key)
      return if pk.blank?
      "#{self.class.model_url}/#{pk}"
    end
    
    module ClassMethods
      def model_url
        "#{Jaysus::Remote.base_url}/#{self.plural_name}"
      end
      
      def find(id)
        super do
          RestClient.get("#{model_url}/#{id}",{
            'Accept' => 'application/json'
          })
        end
      end
    end
  end
end