# Jaysus #

Jaysus is a local/remote persistence/sync framework for MacRuby. It's designed for keeping local copies of responses from a remote JSON api.

## Usage ##
  
    Jaysus::Local.store_dir = '~/.jaysus/'
    Jaysus::Remote.base_url = 'https://user:pass@https://dnsimple.com'
    
    module Domain
      class Base < Jaysus::Base
        primary_key :id
        attribute :name
        attribute :name_server_status
        attribute :registrant_id
        attribute :registration_status
        attribute :expires_at
        attribute :created_at
        attribute :updated_at
        attribute :user_id
      end
      
      class Local < Base
        include Jaysus::Local
      end
      
      class Remote < Base
        include Jaysus::Remote
      end
    end
    
    domain = Site::Remote.new
    domain.title = "This"
    domain.user_id = 1
    domain.save


== Copyright

Copyright (c) 2011 Paul Campbell. See LICENSE.txt for
further details.

