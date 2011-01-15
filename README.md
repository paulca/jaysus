# Jaysus #

Jaysus is a local/remote persistence/sync framework for MacRuby. It's designed for keeping local copies of responses from a remote JSON api.

## Usage ##

    class Site < Jaysus::Base
      primary_key :id
      attribute :title
      attribute :user_id
    end
    
    site = Site.new
    site.title = "This"
    site.user_id = 1
    site.save
    
    Site.all #> [Site(:title => 'This', :user_id => 1)]

== Copyright

Copyright (c) 2011 Paul Campbell. See LICENSE.txt for
further details.

