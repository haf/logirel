require 'logirel/version'
require 'logirel/initer'
require 'logirel/query'
require 'logirel/vs/solution'
require 'logirel/vs/environment'
require 'logirel/tasks/albacore_tasks'
require 'uuid'
require 'thor/group'
require 'fileutils'

module Logirel
  class CLI < Thor
    include Thor::Actions

    desc "init [dir]", "Initialize albacore et al in the given directory. Defaults to the current directory."
    def init(root_dir = Dir.pwd)

      puts "logirel v#{Logirel::VERSION}"
      puts "==============="
      puts "Current dir: #{root_dir}"

      puts ""
      puts "Directories Selection"
      puts "---------------------"

      folder = lambda { |query, default|
        StrQ.new(query, default, STDIN, lambda { |_|
          true # perform validation here if you wish
        }, STDOUT)
      }

      src_folders = Initer.new(root_dir).parse_folders.inspect
      dir = folder.call("Source Directory. Default (src) contains (#{src_folders})", "src").exec
      buildscripts = folder.call("Buildscripts Directory", "buildscripts").exec
      tools = folder.call("Tools Directory", "tools").exec
      initer = Initer.new(root_dir, buildscripts, tools)

      puts ""
      puts "Project Selection"
      puts "-----------------"

      selected_projs = initer.parse_folders.
          find_all { |f| BoolQ.new(f).exec }

      puts "Selected: #{selected_projs.inspect}"


      puts "initing semver in folder #{dir}"
      `semver init`
      puts "done..."
      puts ""
      puts "Project Meta-Data Definitions"
      puts "-----------------------------"
      puts "Let's set up some meta-data!"
      metas = selected_projs.map { |p| initer.meta_for p, dir }

      puts "initing project details"
      initer.init_project_details(metas)

      puts "initing paths"
      initer.init_paths_rb(metas)

      puts "initing environment"
      initer.init_environement_rb

      puts "initing gemfile"
      template 'Gemfile'
      initer.init_gemfile

      puts "initing utils"
      initer.init_utils

      puts "initing rake file"
      template 'Rakefile.rb'
      initer.init_rakefile(metas)
    end
  end
end