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

    def parse_folders src
      src = File.join(@root_dir, src, '*')
      Dir.
          glob(src).
          keep_if { |i|
        projs = File.join(i, "*.{csproj,vbproj,fsproj}")
        File.directory? i and Dir.glob(projs).length > 0
      }.map { |x| File.basename(x) }
    end

    def folders_selection
      puts "Directories Selection"
      puts "---------------------"
      puts "Current dir: #{@root_dir}"
      puts ""

      folder = lambda { |query, default|
        StrQ.new(query, default, STDIN, lambda { |_| true }, STDOUT)
      }

      {
          :src => folder.call("Source Directory. Default (src) contains (#{parse_folders.inspect})", "src").exec,
          :buildscripts => folder.call("Buildscripts Directory", "buildscripts").exec,
          :build => folder.call("Build Output Directory", "build").exec,
          :tools => folder.call("Tools Directory", "tools").exec
      }
    end

    def metadata_interactive selected_projs
      puts "Project Meta-Data Definitions"
      puts "-----------------------------"
      puts "Let's set up some meta-data!"
      puts ""
      selected_projs.map { |p| meta_for p }
    end

    def say_goodbye
      puts ""
      puts "Scaffolding done, now run 'bundle install' to install any dependencies for your albacore rakefile."
      puts ""
      puts "Footnote:"
      puts "If you hack a nice task or deployment script - feel free to send some code to henrik@haf.se to"
      puts "make it available for everyone and get support on it through the community for free!"
    end

    private
    def meta_for p
      base = File.basename(p)

      puts "META DATA FOR: '#{base}'"
      p_dir = File.join(@root_path, base)

      {
          :title => StrQ.new("Title", base).exec,
          :dir => p_dir,
          :test_dir => StrQ.new("Test Directory", base + ".Tests").exec,
          :description => StrQ.new("Description", "Missing description for #{base}").exec,
          :copyright => StrQ.new("Copyright").exec,
          :authors => StrQ.new("Authors").exec,
          :company => StrQ.new("Company").exec,
          :nuget_key => StrQ.new("NuGet key", base).exec,
          :ruby_key => StrQ.new("Ruby key (e.g. 'autotx')", nil, STDIN, lambda { |s| s != nil && s.length > 0 }).exec,
          :guid => UUID.new.generate
      }
    end
  end

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
      folders = helper.folders_selection

      sh %{semver init} do |ok, res|
        if !ok
          puts "could not init semver: #{res.exitstatus} - ensure you have the gem installed"
        end
      end

      puts "Choose what projects to include:"
      selected_projs = helper.parse_folders(folders[:src]).find_all { |f| BoolQ.new(f).exec }

      puts "Give project meta-data:"
      metas = helper.metadata_interactive selected_projs

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