require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Jaysus::Remote do
  let(:site) { Site::Remote.new({ :title => "New Site" }) }
  
  describe "#save" do
    before do
      site.save
    end
    
    describe "remote" do
      subject { site }
      its(:id) { should == 1 }
      its(:id) { should == 1 }
    end
    
    describe "local" do
      subject { Site::Local.find(site.id) }
      its(:title) { should == "New Site" }
    end
  end
end