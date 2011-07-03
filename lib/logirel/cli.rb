require 'logirel/version'
require 'logirel/queries/bool_q'
require 'logirel/queries/str_q'
require 'logirel/vs/solution'
require 'logirel/vs/environment'
require 'logirel/tasks/albacore_tasks'
require 'uuid'
require 'thor/group'
require 'fileutils'

module Logirel

  class CliHelper

    def initialize root_dir
      @root_dir = root_dir

    end

    def parse_folders root_dir
      src = File.join(root_dir, 'src', '*')
      Dir.
          glob(src).
          keep_if { |i|
        projs = File.join(i, "*.{csproj,vbproj,fsproj}")
        File.directory? i and Dir.glob(projs).length > 0
      }.
          map { |x| File.basename(x) }
    end

    def src_selection root_dir
      puts "Directories Selection"
      puts "---------------------"
      puts "Current dir: #{root_dir}"
      puts ""

      folder = lambda { |query, default|
        StrQ.new(query, default, STDIN, lambda { |_| true }, STDOUT)
      }

      src_folders = Initer.new(root_dir).parse_folders.inspect

      folders = {
          :src => folder.call("Source Directory. Default (src) contains (#{src_folders})", "src").exec,
          :buildscripts => folder.call("Buildscripts Directory", "buildscripts").exec,
          :build => folder.call("Build Output Directory", "build").exec,
          :tools => folder.call("Tools Directory", "tools").exec
      }

      initer = Initer.new(src, folders[:buildscripts], folders[:tools])
      puts ""

      return folders, initer
    end

    def metadata_interactive(initer, selected_projs)
      puts "Project Meta-Data Definitions"
      puts "-----------------------------"
      puts "Let's set up some meta-data!"
      puts ""
      selected_projs.map { |p| initer.meta_for p }
    end

    def say_goodbye
      puts ""
      puts "Scaffolding done, now run 'bundle install' to install any dependencies for your albacore rakefile."
      puts ""
      puts "Footnote:"
      puts "If you hack a nice task or deployment script - feel free to send some code to henrik@haf.se to"
      puts "make it available for everyone and get support on it through the community for free!"
    end

  end

  class CLI < Thor
    include Thor::Actions
    include Logirel::Tasks

    source_paths << File.expand_path("../../../templates", __FILE__)
    source_paths << Dir.pwd

    desc "init [root-dir] [template-file]", "Initialize rakefile w/ albacore. Defaults to the current directory."

    def init(root_dir = Dir.pwd)
      helper = CliHelper.new

      puts "logirel v#{Logirel::VERSION}"
      folders = helper.src_selection root_dir

      sh %{semver init} do |ok, res|
        if !ok
          puts "could not init semver: #{res.exitstatus}"
        end
      end

      puts "Choose what projects to include:"
      selected_projs = helper.parse_folders.find_all { |f| BoolQ.new(f).exec }
      puts "Give project meta-data:"
      metas = helper.parse_folders(selected_projs)

      template 'Gemfile'
      inside folders[:buildscripts] do |bs|
        template 'project_details.rb', File.join(bs, "project_details.rb")
        template 'paths.rb'
        template 'environment.rb'
        template 'utils.rb'
      end

      template 'Rakefile.rb', 'Rakefile.rb', metas
      helper.say_goodbye
    end
  end
end