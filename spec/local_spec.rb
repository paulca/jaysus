require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Jaysus::Local do
  module Site
    class Base < Jaysus::Base
      primary_key :id
      attribute :id
      attribute :title
      attribute :user_id
    end
    
    class Local < Base
      include Jaysus::Local
    end
    
    class Remote < Base
      include Jaysus::Remote
    end
  end
  let(:site) { Site::Local.new({ :title => "New Site", :user_id => 1 }) }
  
  describe Site::Local do
    subject { Site::Local }
    its(:model_name) { should == 'Site' }
    its(:store_file_dir_name) { should == 'sites' }
  end
  
  describe "finder methods" do
    before(:each) { FileUtils.cp('spec/fixtures/1', Site::Local.store_file_dir) }
    
    describe ".all" do
      subject { Site::Local.all }
      its(:length) { should == 1}
      its(:first) { should be_a_kind_of(Site::Local) }
    end
    
    describe ".find" do
      subject { Site::Local.find(1) }
      it { should_not be_nil }
      its(:title) { should == "A nice fixture" }
    end
    
    describe ".find_by_x" do
      subject { Site::Local.find_by_title("A nice fixture") }
      it { should_not be_nil }
      its(:title) { should == "A nice fixture" }
    end
  end
  
  describe ".new" do
    subject { site }
    
    its(:title) { should == "New Site"}
    its(:user_id) { should == 1 }
  end
  
  describe "#to_json" do
    let(:decoded_site) { ActiveSupport::JSON.decode(site.to_json)['site'] }
    
    it("should have a title") { decoded_site['title'].should == "New Site" }
    it("should have a user id"){ decoded_site['user_id'].should == 1 }
  end
  
  describe "#save" do
    subject { site }
    
    before do
      site.save
    end
    
    it { should be_persisted }  
    its(:id) { should be_a_kind_of(String) }
  end
  
  describe "#update_attributes" do
    subject { site.update_attributes(:title => "Newer Site::Local")}
    its(:title) { should == "Newer Site::Local"}
  end
  
end
