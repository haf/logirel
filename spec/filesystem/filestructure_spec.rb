require 'logirel/initer'
require 'logirel/version'
require 'logirel/nuget'
require 'logirel/initer'
require 'construct'
require 'FileUtils'
require File.dirname(__FILE__) + '/../support/with_sample_projects'
include Logirel

describe Initer, "setting up folder structure" do
  
  before(:each) do
    @tmp = "fs-" + rand().to_s
	Dir.mkdir(@tmp)	
	@r = Initer.new(@tmp)
	@r.create_structure
	@bs = File.join(@r.root_path, "buildscripts")
  end
  
  subject { @r }
  
  # after(:each) do
	# FileUtils.rm_rf(@tmp) while Dir.exists?(@tmp)
  # end
  
  it { should respond_to :root_path }
  
  context "when we have an existing project" do
    before {
	  abc_projects(@r.root_path)
	}
	it "initer should correctly parse the names of existing projects" do
      @r.parse_folders.should =~ ['A', 'C']
    end
  end
  
  it "should create the correct folder structure" do
	@r.create_structure
	Dir.exists?(@bs).should be_true
	Dir.exists?(File.join(@tmp, "src")).should be_true
  end
  
  it "should create paths.rb" do
	@r.create_paths_rb
	File.exists?(File.join(@bs, "paths.rb")).should be_true
  end
  
  it "should create environment.rb" do
    @r.create_environement_rb
	File.exists?(File.join(@bs, "environment.rb")).should be_true
  end
  
  it "should create project_details.rb" do
    @r.create_project_details_rb
	File.exists?(File.join(@bs, "project_details.rb")).should be_true
  end
end