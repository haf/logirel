require 'logirel/version'
require 'logirel/initer'
require 'logirel/queries/bool_q'
require 'logirel/queries/str_q'
require 'logirel/vs/solution'
require 'logirel/vs/environment'
require 'logirel/tasks/albacore_tasks'
require 'uuid'
require 'thor/group'
require 'fileutils'

module Logirel
  class CLI < Thor
    include Thor::Actions
    include Logirel::Tasks

    source_paths << File.expand_path("../../../templates", __FILE__)
    source_paths << Dir.pwd

    def project_selection(initer)
      puts "Project Selection"
      puts "-----------------"

      selected_projs = initer.parse_folders.
          find_all { |f| BoolQ.new(f).exec }

      puts "selected: #{selected_projs.inspect}"
      puts ""
      selected_projs
    end

    def print_header
      puts "logirel v#{Logirel::VERSION}"
      puts "==============="
    end

    def src_selection(root_dir)
      puts "Directories Selection"
      puts "---------------------"
      puts "Current dir: #{root_dir}"
      puts ""

      folder = lambda { |query, default|
        StrQ.new(query, default, STDIN, lambda { |_|
          true # perform validation here if you wish
        }, STDOUT)
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

    def init_semver(dir)
      puts "initing semver in folder #{dir}"
      `semver init`
      puts ""
    end

    def metadata_interactive(initer, selected_projs)
      puts "Project Meta-Data Definitions"
      puts "-----------------------------"
      puts "Let's set up some meta-data!"
      puts ""

      metas = selected_projs.map { |p| initer.meta_for p }
      metas
    end

    desc "init [root-dir] [template-file]", "Initialize rakefile w/ albacore. Defaults to the current directory."
    def init(root_dir = Dir.pwd)

      print_header()

      folders, initer = src_selection(root_dir)
      init_semver(root_dir)

      selected_projs = project_selection(initer)
      metas = metadata_interactive(initer, selected_projs)

      puts "initing gemfile"
      template 'Gemfile'
      #initer.init_gemfile

      inside folders[:buildscripts] do |bs|

        puts "initing project details"
        template 'project_details.rb', File.join(bs, "project_details.rb")
        #initer.init_project_details(metas)

        puts "initing paths"
        template 'paths.rb'
        #initer.init_paths_rb(metas)

        puts "initing environment"
        template 'environment.rb'
        #initer.init_environement_rb

        puts "initing utils"
        template 'utils.rb'
        #initer.init_utils

      end

      puts "initing rake file"
      template 'Rakefile.rb', 'Rakefile.rb', metas
      # initer.init_rakefile(metas)

      puts ""
      puts "Scaffolding done, now run 'bundle install' to install any dependencies for your albacore rakefile."
      puts ""
      puts "Footnote:"
      puts "If you hack a nice task or deployment script - feel free to send some code to henrik@haf.se to"
      puts "make it available for everyone and get support on it through the community for free!"
    end
  end
end