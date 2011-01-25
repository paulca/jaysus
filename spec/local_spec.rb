require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Jaysus::Local do
  let(:site) { Site::Local.new({ :title => "New Site", :user_id => 1 }) }
  
  describe Site::Local do
    subject { Site::Local }
    its(:model_name) { should == 'Site' }
    its(:store_file_dir_name) { should == 'sites' }
  end
  
  describe "finder methods" do
    before(:each) { FileUtils.cp('spec/fixtures/1', Site::Local.store_file_dir) }
    
    describe ".store_file_dir_name" do
      context "normal" do
        subject { Site::Local }
        its(:store_file_dir_name) { should == 'sites' }
      end
      context "within a module" do
        subject { Kalipso::Site::Local }
        its(:store_file_dir_name) { should == 'sites' }
      end
    end
    
    describe ".all" do
      context "normal" do
        subject { Site::Local.all }
        its(:length) { should == 1}
        its(:first) { should be_a_kind_of(Site::Local) }
      end
      context "within a module" do
        subject { Kalipso::Site::Local.all }
        its(:length) { should == 1}
        its(:first) { should be_a_kind_of(Kalipso::Site::Local) }
      end
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
    
    describe ".find_or_create_by_x" do
      subject { Site::Local.find_or_create_by_id(2) }
      it { should_not be_nil }
      its(:title) { should be_blank }
      its(:id) { should == 2 }
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
    subject { site.update_attributes(:title => "Newer Site")}
    its(:title) { should == "Newer Site" }
  end
  
  describe "#destroy" do
    before { site.save; site.destroy }
    subject { site.store_file }
    it { should_not exist }
  end
  
end
