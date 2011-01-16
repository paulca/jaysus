module Jaysus
  module Local
    
    def self.store_dir
      @store_dir ||= Pathname.new('.')
    end
    
    def self.store_dir=(dir)
      @store_dir = Pathname.new(dir)
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    def destroy
      super do
        store_file.delete
        self
      end
    end
    
    def save
      super do
        store_file.open('w') do |file|
          file.write(self.to_json)
        end
        self
      end
    end
    
    module ClassMethods
      def all
        out = []
        Dir[store_file_dir.join('*')].each do |id|
          out << find(id)
        end
        out
      end

      def find(id)
        super do
          store_file_dir.join("#{id}").read
        end
      end
    end
    
  end
end