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
        records = []
        Dir[store_file_dir.join('*')].each do |id|
          records << find(id)
        end
        records
      end

      def find(id)
        super do
          store_file_dir.join("#{id}").read
        end
      end
    end
    
  end
end