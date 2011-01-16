require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Jaysus::Remote do
  let(:site) { Site::Remote.new({ :title => "New Site" }) }
  
  describe ".find" do
    subject { Site::Remote.find(42) }
    it { should_not be_nil }
    its(:title) { should == 'The Answer to Life, the Universe and Everything'}
    its(:user_id) { should == 42 }
  end
  
  describe "#save" do
    before do
      RestClient.should_receive(:post).with(
        'http://testapi/sites',
        site.to_json,
        {
          'Content-Type' => 'application/json'
        }
      ).and_return(File.read('spec/fixtures/new_site.json'))
      site.save
    end
    
    subject { site }
    its(:id) { should == 2 }
    its(:title) { should == "New Site" }
  end
  
  describe "#update_attributes" do
    before do
      RestClient.should_receive(:get).with(
        'http://testapi/sites/42',
        {
          'Accept' => 'application/json'
        }
      ).and_return(File.read('spec/fixtures/find_site.json'))
      
      RestClient.should_receive(:put).with(
        'http://testapi/sites/42',
        "{\"site\":{\"title\":\"Monster!\",\"id\":42,\"user_id\":42}}",
        {
          'Content-Type' => 'application/json'
        }
      ).and_return(File.read('spec/fixtures/update_site.json'))
    end
    
    let(:site) { Site::Remote.find(42)}
    subject { site.update_attributes(:title => 'Monster!') }
    
    its(:title){ should == 'Monster!'}
  end
end