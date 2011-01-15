module Jaysus
  
  class Base
    def self.attribute(name)
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
    
    def self.primary_key(name)
      
    end
    
    def initialize(set_attrs = {})
      set_attrs.each_pair do |attr, value|
        self.send("#{attr}=", value)
      end
    end
    
  end
  
end