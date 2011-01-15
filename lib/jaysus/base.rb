module Jaysus
  
  class Base
    extend ActiveModel::Naming
    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON
    
    def self.attribute(name)
      self.attributes << name
      class_eval do
        define_method(name) do               # def title
          instance_variable_get("@#{name}")  #   @title 
        end                                  # end
        
        define_method("#{name}=") do |value|         # def title=(value)
          instance_variable_set("@#{name}", value)  #   @title = value
        end                                          # end
      end
    end
    
    def self.attributes
      @attributes ||= []
    end
    
    def self.find(id)
      new(
        ActiveSupport::JSON.decode(
          store_file_dir.join("#{id}.json").read
        )[self.model_name.singular]
      )
    end
    
    def self.primary_key(name = nil)
      @primary_key = name if name.present?
      @primary_key
    end
    
    def self.store_file_dir
      dir = Local.store_dir.join(store_file_dir_name)
      dir.mkpath unless dir.exist?
      dir
    end
    
    def self.store_file_dir_name
      self.model_name.plural
    end
    
    def initialize(set_attrs = {})
      @attributes = attributes
      set_attrs.each_pair do |attr, value|
        self.send("#{attr}=", value)
      end
    end
    
    def attributes
      out = {}
      self.class.attributes.each do |attribute|
        out[attribute.to_s] = send(attribute)
      end
      out
    end
    
    def save
      store_file.open('w') do |file|
        file.write(self.to_json)
      end
    end
    
    def store_file
      self.class.store_file_dir.join(store_file_name)
    end
    
    def store_file_name
      pk = send(self.class.primary_key)
      if pk.blank?
        pk = ActiveSupport::SecureRandom.hex(32) 
        send("#{self.class.primary_key}=", pk)
      end
      "#{send(self.class.primary_key)}.json"
    end
    
    def persisted?
      store_file.exist?
    end
  end
  
end