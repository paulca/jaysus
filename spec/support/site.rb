module Site
  class Base < Jaysus::Base
    primary_key :id
    attribute :id
    attribute :title
    attribute :user_id
  end
  
  class Local < Base
    include Jaysus::Local
    attribute :path
  end
  
  class Remote < Base
    include Jaysus::Remote
  end
end