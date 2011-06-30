require 'logirel/initer'
require 'logirel/version'
require 'logirel/utils'
require 'logirel/initer'
require 'construct'
require 'FileUtils'
require File.dirname(__FILE__) + '/../support/with_sample_projects'
include Logirel

describe Initer, "setting up folder structure" do

  before(:each) do
    @tmp = "fs-" + rand().to_s
    @tmp_bs = "buildscripts"
    Dir.mkdir(@tmp)
    @r = Initer.new(@tmp, @tmp_bs)
    @r.create_structure
    @bs = File.join(@r.root_path, @r.buildscripts_path)
  end

  subject { @r }

  after(:each) do
    FileUtils.rm_rf(@tmp) while Dir.exists?(@tmp)
  end

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

  it "should create environment.rb" do
    @r.init_environement_rb
    File.exists?(File.join(@bs, "environment.rb")).should be_true
  end

  it "should create project_details.rb" do
    @r.init_project_details([{
                                 :ruby_key => "p_ruby",
                                 :dir => "p_dir"
                             }])
    File.exists?(File.join(@bs, "project_details.rb")).should be_true
  end
end