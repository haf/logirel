require 'logirel/version'
require 'logirel/queries/bool_q'
require 'logirel/queries/str_q'
require 'logirel/vs/solution'
require 'logirel/vs/environment'
require 'logirel/tasks/albacore_tasks'
require 'logirel/cli_helper'
require 'uuid'
require 'thor'
require 'fileutils'

module Logirel
  class CLI < Thor
    include Thor::Actions
    include Logirel::Tasks

    source_paths << File.expand_path("../../../templates", __FILE__)
    source_paths << Dir.pwd

    default_task :init
    class_option "verbose",  :type => :boolean, :banner => "Enable verbose output mode", :aliases => "-v"

    desc "init [[--root=]ROOT-DIR] [[--template=]FILENAME]", "Initialize rakefile w/ albacore. Defaults to the current directory"
    long_desc <<-D
      Init scaffolds a directory structure for building the .Net project with albacore/rake. It takes as parameters
      the root directory, which contains a 'src' folder, which should contain the projects. It aims not to overwrite
      existing infrastructure, should such infrastructure exist.
    D
    method_option "root", :type => :string, :banner => "Perform the initialization in the given root directory"
    method_option "template", :type => :string, :banner => "Specify the initialization template to use"
    def init
      opts = options.dup
      helper = CliHelper.new opts.fetch("root", Dir.pwd)

      puts "logirel v#{Logirel::VERSION}"
      @folders = helper.folders_selection
      @files = helper.files_selection folders

      puts "Choose what projects to include:"
      selected_projs = helper.parse_folders(folders[:src]).find_all { |f| BoolQ.new(f).exec }

      puts "Give project meta-data:" unless selected_projs.empty?
      @metas = helper.metadata_interactive selected_projs

      puts "initing main environment"
      run 'semver init'
      template 'Gemfile'
      inside folders[:buildscripts] do |bs|
        template 'project_details.rb'
        template 'paths.rb.tt'
        template 'environment.rb'
        template 'utils.rb'
      end

      template 'Rakefile.rb'
      helper.say_goodbye
    end

    protected
    def metas
      @metas ||= {}
    end

    def folders
      @folders ||= {}
    end

    def files
      @files ||= {}
    end
  end
end