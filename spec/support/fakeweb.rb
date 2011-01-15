require 'fakeweb'
FakeWeb.allow_net_connect = false

FakeWeb.register_uri(:post, 'http://testapi/sites', :body => File.read('spec/fixtures/new_site.json'))