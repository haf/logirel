require 'logirel/version'
require 'logirel/queries'
require 'logirel/vs'
require 'logirel/tasks/albacore_tasks'
require 'logirel/cli_helper'
require 'thor'
require 'fileutils'

module Logirel
  class CLI < Thor
    include Thor::Actions
    include Logirel::Tasks
    include Logirel::Queries
    include Logirel::VS

    source_paths << File.expand_path("../templates", __FILE__)
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
    method_option "raketempl", :type => :string, :banner => "Specify the rakefile template to use"
    def init(root = Dir.pwd, raketempl = 'Rakefile.tt')
      #opts = options.dup
      helper = CliHelper.new root
      @root = root

      puts "logirel v#{Logirel::VERSION}"

      @folders = helper.folders_selection
      sln_path = helper.find_sln folders
      sln = Solution.new sln_path
      selected_projs = sln.projects.find_all { |f| BoolQ.new(f.name, !f.test?).exec }  # don't include test projs by default
      @metas = selected_projs.empty? ? [] : helper.metadata_interactive(selected_projs)
      to_package = @metas.find_all{|p| p[:create_package] }

      puts "initing main environment"
      run 'semver init'

      template 'Gemfile.tt',          File.join(root, 'Gemfile')
      template 'gitignore.tt',        File.join(root, '.gitignore')
      template 'project_details.tt',  File.join(root, folders[:buildscripts], 'project_details.rb')
      template 'paths.tt',            File.join(root, folders[:buildscripts], 'paths.rb')
      template 'environment.tt',      File.join(root, folders[:buildscripts], 'environment.rb')
      template 'utils.tt',            File.join(root, folders[:buildscripts], 'utils.rb')
      template raketempl,             File.join(root, BUILD_FILE)

      generate_asm_info = BoolQ.new("Create common assembly info file?").exec
      build_sln = BoolQ.new("Add msbuild task for sln file?").exec
      framework_targets = BoolQ.new("Setup more than the default framework target?").exec
      initialize_owrap = BoolQ.new("Initialize projects with openwrap?", false).exec
      setup_default_task = BoolQ.new("Setup default task?").exec

      build_dep = ["env:release"]

      if generate_asm_info then
        assembly_info_task @metas.first(), { :depends => build_dep }
        build_dep.push 'assemblyinfo'
      end

      targets = []
      while targets.empty? do
        targets = ['net40', 'net35', 'net20', 'mono26', 'mono28', 'mono210'].
                  collect { |t| return t, BoolQ.new(t, false).exec } if framework_targets
        puts "you need to build for something, silly you! try again!" if targets.empty?
      end

      if build_sln then
        msbuild_task
        build_dep.push "msbuild" if build_sln

        outputs = { :depends => @metas.collect { |m| :"#{m[:ruby_key]}_output" } }
        @metas.each { |p| output_task p, {:depends=>[:msbuild]} }
        append_file BUILD_FILE, "task :output#{ inject_dependency outputs }\n"

        build_dep.push "output"
      end

      if not to_package.empty? then
        nuspecs = { :depends => to_package.collect{|p| :"#{p[:ruby_key]}_nuspec" } }
        append_to_file BUILD_FILE, "task :nuspecs#{ inject_dependency nuspecs }\n"
        to_package.each{ |p| nuspec_task p }

        nugets = { :depends => [:"env:release", :nuspecs].concat(to_package.collect{|p| :"#{p[:ruby_key]}_nuget" }) }
        append_to_file BUILD_FILE, "task :nugets#{inject_dependency nugets}\n"
        to_package.each{ |p| nuget_task p }

        build_dep.push "nugets"

        if BoolQ.new("Create 'push to nuget server'-task?").exec then
          pushes = { :depends => [:"env:release"].concat(to_package.collect { |p| :"#{p[:ruby_key]}_nuget_push" }) }
          append_to_file BUILD_FILE, "task :publish#{ inject_dependency pushes }\n"
          to_package.each { |p| nugetpush_task p }
        end
      end

      if setup_default_task then
        opts = { :depends => build_dep }
        append_to_file File.join(@root, BUILD_FILE), "task :default #{ inject_dependency opts }"
      end

      run 'git init'
      run 'git add .'

      helper.say_goodbye
    end

    protected
    def metas
      @metas ||= {}
    end

    def folders
      @folders ||= {}
    end
  end
end