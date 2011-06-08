require 'logirel/initer'
require 'logirel/version'
require 'logirel/nuget'
require 'logirel/initer'
require 'construct'

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
	  r = Logirel::Initer.new(c.to_s)
	  Dir.exists?(c+'buildscripts').should == false
	  r.create_structure
	  Dir.exists?(c+'buildscripts').should == true
	  Dir.exists?(c+'src').should == true
	end
  end
  
  it "should correctly parse the names of existing projects" do
    
    Construct::within_construct do |c|
      # given files	
	  c.directory('src/A')
	  c.directory('src/B')
	  c.directory('src/C')
	  c.file('src/A/A.csproj') do |f|
	    f.puts "cs proj file ... xml in here"
	  end
	  
	  c.file('src/C/HelloWorld.vbproj')
	  
	  # initer should parse names:
	  r = Logirel::Initer.new(c.to_s)
	  r.parse_folders.should =~ ['A', 'C']
	end
	
  end
  
  it "should create Rakefile.rb" do
    pending("strange error... sleep on it")
    Construct::within_construct do |c|
	  r = Logirel::Initer.new(c.to_s)
	  r.init_rakefile
	  c.file('Rakefile.rb').exists?.should == true
	end
  end
  
  it "should have bundler at the top of the rake file" do
    pending("strange error, sleep on it...")
	
    Construct::within_construct do |c|
	  r = Logirel::Initer.new(c.to_s)
	  Directory.exists?(c.directory).should == true
	  r.init_rakefile
	end
  end
end
