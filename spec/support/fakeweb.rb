require 'fakeweb'
FakeWeb.allow_net_connect = false

FakeWeb.register_uri(:get, 'http://testapi/sites/42', {
  :body => File.read('spec/fixtures/find_site.json')
})