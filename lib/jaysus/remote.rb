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
    
    def save
      super do
        response = RestClient.post(self.class.model_url, self.to_json, {
          'Content-Type' => 'application/json'
        })
        decoded_response = ActiveSupport::JSON.decode(
          response
        )[self.class.singular_name]
        
        record = self.class.local_base.
                   find_or_create_by_id(decoded_response['id'])
        
        record.update_attributes(decoded_response)
        record
      end
    end
    
    module ClassMethods
      def model_url
        "#{Jaysus::Remote.base_url}/#{self.plural_name}"
      end
    end
  end
end