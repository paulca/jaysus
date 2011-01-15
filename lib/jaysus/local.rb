module Jaysus
  module Local
    
    def self.store_dir
      @store_dir ||= Pathname.new('.')
    end
    
    def self.store_dir=(dir)
      @store_dir = Pathname.new(dir)
    end
    
  end
end