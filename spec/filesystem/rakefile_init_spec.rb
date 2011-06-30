require 'logirel/initer'
require 'logirel/version'
require 'logirel/utils'
require 'logirel/initer'
require 'construct'
require 'FileUtils'

describe Logirel::Initer, "when initilizing rake file" do

  before(:each) do
    @tmp = "fs-" + rand().to_s
    @tmp_bs = "buildscripts"
    Dir.mkdir(@tmp)
    @r = Logirel::Initer.new(@tmp, @tmp_bs)
    @r.create_structure
    @bs = File.join(@r.root_path, @r.buildscripts_path)
  end

  subject { @r }

  after(:each) do
    FileUtils.rm_rf(@tmp) while Dir.exists?(@tmp)
  end

  it "should be created" do
    @r.init_rakefile({
                         :ruby_key => "p_ruby_key",
                         :test2 => "p_test2"
                     })
    File.exists?(File.join(@bs, "Rakefile.rb")).should be_true
  end
end