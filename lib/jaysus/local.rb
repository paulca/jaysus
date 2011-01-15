module Jaysus
  module Local
    
    def self.store_dir
      @store_dir ||= Pathname.new('.')
    end
    
    def self.store_dir=(dir)
      @store_dir = Pathname.new(dir)
    end
    
    def save
      super do
        store_file.open('w') do |file|
          file.write(self.to_json)
        end
        self
      end
    end
    
  end
end