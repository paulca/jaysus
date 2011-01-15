require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Jaysus" do
  class Site < Jaysus::Base
    primary_key :id
    attribute :title
    attribute :user_id
  end
  
  describe ".new" do
    let(:site) { Site.new({ :title => "New Site", :user_id => 1 }) }
    subject { site }
    
    its(:title) { should == "New Site"}
    its(:user_id) { should == 1}
  end
  
end
