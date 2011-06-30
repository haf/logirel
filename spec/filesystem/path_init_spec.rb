# require 'logirel/initer'
# require 'logirel/version'
# require 'logirel/nuget'
# require 'logirel/initer'
# require 'construct'
# require 'FileUtils'

# describe Logirel::Initer, "when initilizing paths file" do
# pending "too much of an integration test now"

# before(:each) do
# @tmp = "fs-" + rand().to_s
# @tmp_bs = "buildscripts"
# Dir.mkdir(@tmp)
# @r = Logirel::Initer.new(@tmp, @tmp_bs)
# @r.create_structure
# @bs = File.join(@r.root_path, @r.buildscripts_path)
# end

# subject { @r }

# after(:each) do
# FileUtils.rm_rf(@tmp) while Dir.exists?(@tmp)
# end

# it "should be created" do
# @r.init_paths_rb({
# :dir => "p_dir",
# :ruby_key => "p_ruby_key",
# :id => "p_id"
# })
# File.exists?(File.join(@bs, "paths.rb")).should be_true
# end

# end 