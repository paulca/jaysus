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
    
    def self.create(attrs = {})
      new(attrs).save
    end
    
    def self.find(id, &block)
      new(decode(id, &block))
    end
    
    def self.find_or_create_by_attributes(attributes, *values)
      search = find_by_attributes(attributes, *values)
      return search unless search.blank?
      attrs = {}
      attributes.zip(values).each do |pair|
        attrs[pair.first] = pair.last
      end
      create(attrs)
    end
    
    def self.find_by_attributes(attributes, *values)
      find_all_by_attributes(attributes, *values).first
    end
    
    def self.find_all_by_attributes(attributes, *values)
      all.each.select do |record|
        attributes.zip(values).all? do |matcher|
          record.send(matcher.first) == matcher.last
        end
      end
    end
    
    def self.decode(id, &block)
      ActiveSupport::JSON.decode(
        yield
      )[self.store_file_dir_name.singularize]
    end
    
    def self.model_base
      "#{model_name}::Base".constantize
    end
    
    def self.local_base
      "#{model_name}::Local".constantize
    end
    
    def self.remote_base
      "#{model_name}::Remote".constantize
    end
    
    def self.model_name
      parts = super.reverse.split('::',2).reverse.map { |p| p.reverse }
      ActiveModel::Name.new(parts.first.constantize)
    end
    
    def self.plural_name
      model_name.plural
    end
    
    def self.singular_name
      model_name.singular
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
    
    def self.object_name
      self.model_name.split('::').last
    end
    
    def self.plural_object_name
      self.object_name.underscore.pluralize
    end
    
    def self.singular_object_name
      self.object_name.underscore.singularize
    end
    
    def self.store_file_dir_name
      self.plural_object_name
    end
    
    def self.method_missing(method, *args)
      if method.to_s.match(/^find_by/)
        attrs = method.to_s.gsub(/^find_by_/, '').split('_and_')
        find_by_attributes(attrs, *args)
      elsif method.to_s.match(/^find_or_create_by/)
        attrs = method.to_s.gsub(/^find_or_create_by_/, '').split('_and_')
        find_or_create_by_attributes(attrs, *args)
      else
        super
      end
    end
    
    def initialize(set_attrs = {})
      set_attributes(set_attrs)
    end
    
    def attributes
      out = {}
      (self.class.model_base.attributes + self.class.attributes).each do |attribute|
        out[attribute.to_s] = send(attribute)
      end
      out
    end
    
    def attributes=(attrs = {})
      set_attributes(attrs)
    end
    
    def destroy(&block)
      yield
    end
    
    def update_attributes(attrs)
      set_attributes(attrs)
      save
    end
    
    def set_attributes(attrs)
      attrs.each_pair do |attr, value|
        self.send("#{attr}=", value)
      end
    end
    
    def save(&block)
      yield if block_given?
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
    
    def to_json
      {}.tap do |outer_hash|
        outer_hash[self.class.store_file_dir_name.singularize] = {}.tap do |inner_hash|
          (self.class.model_base.attributes + self.class.attributes).each do |attribute|
            if self.send(attribute).present?
              inner_hash[attribute] = self.send(attribute)
            end
          end
        end
      end.to_json
    end
    
    def persisted?
      store_file.exist?
    end
  end
  
end