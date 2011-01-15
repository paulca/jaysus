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
          instance_variable_set("@#{name}", value)   #   @title = value
        end                                          # end
      end
    end
    
    def self.attributes
      @attributes ||= []
    end
    
    def self.all
      out = []
      Dir[store_file_dir.join('*')].each do |id|
        out << find(id)
      end
      out
    end
    
    def self.find(id)
      new(decode(id))
    end
    
    def self.find_by_attributes(attributes, *values)
      find_all_by_attributes(attributes, *values).first
    end
    
    def self.find_all_by_attributes(attributes, *values)
      all.each.select do |record|
        attributes.zip(values).each do |matcher|
          record.send(matcher.first) == matcher.last
        end
      end
    end
    
    def self.decode(id)
      ActiveSupport::JSON.decode(
        store_file_dir.join("#{id}").read
      )[self.model_name.singular]
    end
    
    def self.model_base
      "#{model_name}::Base".constantize
    end
    
    def self.model_name
      ActiveModel::Name.new(super.split('::').first.constantize)
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
    
    def self.method_missing(method, *args)
      if method.to_s.match(/^find_by/)
        attrs = method.to_s.gsub(/^find_by_/, '').split('_and_')
        find_by_attributes(attrs, *args)
      else
        super
      end
    end
    
    def initialize(set_attrs = {})
      @attributes = attributes
      set_attrs.each_pair do |attr, value|
        self.send("#{attr}=", value)
      end
    end
    
    def attributes
      out = {}
      self.class.model_base.attributes.each do |attribute|
        out[attribute.to_s] = send(attribute)
      end
      out
    end
    
    def update_attributes(attributes)
      attributes.each_pair do |attribute, value|
        self.send("#{attribute}=", value)
      end
      save
    end
    
    def save
      store_file.open('w') do |file|
        file.write(self.to_json)
      end
      self
    end
    
    def store_file
      self.class.store_file_dir.join(store_file_name)
    end
    
    def store_file_name
      pk = send(self.class.model_base.primary_key)
      if pk.blank?
        pk = ActiveSupport::SecureRandom.hex(32) 
        send("#{self.class.model_base.primary_key}=", pk)
      end
      "#{send(self.class.model_base.primary_key)}"
    end
    
    def persisted?
      store_file.exist?
    end
  end
  
end