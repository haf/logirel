require 'logirel/initer'
require 'logirel/version'
require 'logirel/nuget'
require 'logirel/initer'
require 'construct'
require 'FileUtils'

describe Logirel::Initer, "when starting a new project" do

  before(:each) do
    include Construct::Helpers
    @i = Logirel::Initer.new
  end
  
  after(:each) do
    Construct.destroy_all!
  end
  
  it "should start by performing an upgrade" do
    @i.get_commands[0].should eql("gem update")
  end
  
  it "should then proceed running bundle install" do
    @i.get_commands[1].should eql("bundle install")
  end
  
  it "should then update nuget" do
    @i.get_commands[2].include?('update').should == true
  end
 
  it "should be able to know when to download from codeplex" do
    @i.nuget_from_codeplex([1,3], [1,1]).should == true
	@i.nuget_from_codeplex([1,3], [1,4]).should == false
  end

  it "should create the correct folder structure" do
    Construct::within_construct do |c|
	  r = Logirel::Initer.new(c)
	  Dir.exists?(c+'buildscripts').should == false
	  r.create_structure
	  Dir.exists?(c+'buildscripts').should == true
	  Dir.exists?(c+'src').should == true
	end
  end
  
end