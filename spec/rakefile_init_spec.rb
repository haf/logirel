require 'logirel/initer'
require 'logirel/version'
require 'logirel/nuget'
require 'logirel/initer'
require 'construct'
require 'FileUtils'

describe Logirel::Initer, "when initilizing rake file" do
  
  attr_accessor :tmp, :r

  before(:each) do
    @tmp = "test-temp"
	Dir.mkdir(@tmp) unless Dir.exists?(@tmp)	
	@r = Logirel::Initer.new(@tmp)
  end
  
  after(:each) do
	FileUtils.rm_rf(@tmp) if Dir.exists?(@tmp)
  end

  it "should be created" do
	@r.init_rakefile
	File.exists?(File.join(@tmp, 'Rakefile.rb')).should == true
  end
end