<<<<<<< HEAD
require 'logirel/initer'
require 'FileUtils'
require 'logirel/q_model'

describe Logirel::Initer, "when initilizing project details" do 
  
  before(:each) do 
    @temp = "buildscripts"
	Dir.mkdir(@temp) unless Dir.exists?(@temp)
	@r = Logirel::Initer.new(@temp)
	
	@r.init_project_details(@temp, {
	    :ruby_key => "p_ruby", 
		:dir => "p_dir"
	  })
  end
  
  after(:each) do
    FileUtils.rm_rf(@temp) if Dir.exists?(@temp)
  end
  
  it "should create project_details.rb" do
    File.exists?(File.join(@temp, "project_details.rb")).should be_true
  end
  
=======
require 'logirel'
require 'FileUtils'

describe Logirel::Initer, "when initilizing project details" do 
  
  before(:each) do 
    @temp = "fs-" + rand().to_s
	Dir.mkdir(@temp) unless Dir.exists?(@temp)
	@r = Logirel::Initer.new(@temp)
  end
  
  after(:each) do
    FileUtils.rm_rf(@temp) if Dir.exists?(@temp)
  end
  
  
>>>>>>> 6198599ec89da15594a12554a5acf6b34558958c
end