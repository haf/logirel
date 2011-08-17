require 'logirel/queries'
require 'logirel/vs'
require 'uuidtools'

module Logirel
  class CliHelper
    include Logirel::Queries
    include Logirel::VS

    def initialize root_dir
      @root_dir = root_dir
      @env = Environment.new
    end

    # src: relative path!
    def parse_folders src
      puts ""
      puts "Projects Selection"
      puts "---------------------"
      puts "Choose what projects to include (don't include test-projects):"
      parse_folders_inner src
    end

    def parse_folders_inner src
      src = File.join(@root_dir, src, '*')
      Dir.
          glob(src).
          keep_if { |i|
        projs = File.join(i, "*.{csproj,vbproj,fsproj}")
        File.directory? i and Dir.glob(projs).length > 0
      }.map { |x| File.basename(x) }
    end

    def folders_selection
      puts ""
      puts "Directories Selection"
      puts "---------------------"
      puts "Current dir: #{@root_dir}, #{Dir.entries(@root_dir).keep_if{|x|
        x != '.' && x != '..' && File.directory?(File.join(@root_dir, x))
      }.
          empty? ? 'which is empty.' : 'which contains folders.'}"
      puts ""

      build_dir =   StrQ.new("Build Output Directory", "build").exec

      {
          :src => StrQ.new("Source Directory. Default (src) contains (#{parse_folders_inner('src').inspect})", 'src').exec,
          :buildscripts => StrQ.new("Buildscripts Directory", "buildscripts").exec,
          :build => build_dir,
          :tools => StrQ.new("Tools Directory", "tools").exec,
          :tests => StrQ.new("Test Output Directory", "#{build_dir}/tests").exec,
          :nuget => StrQ.new("NuGet Directory", "#{build_dir}/nuget").exec,
          :nuspec => StrQ.new("NuSpec Directory", "#{build_dir}/nuspec").exec
      }
    end

    # folders: hash (as defined above), of folder paths
    def find_sln folders
      puts "Looking at src folder: '#{folders[:src]}'."
      first_sln = Dir.glob(File.join(@root_dir, folders[:src],"*.sln")).first || ""
      StrQ.new("sln file", File.join(folders[:src], File.basename(first_sln))).exec
    end

    def metadata_interactive selected_projs
      puts ""
      puts "Project Meta-Data Definitions"
      puts "-----------------------------"
      puts "Let's set up some meta-data!"
      puts ""
      selected_projs.map { |p| meta_for p }
    end

    def say_goodbye
      puts ""
      puts "SCAFFOLDING DONE! Now run 'bundle install' to install any dependencies for your albacore rakefile,"
      puts " and git commit to commit changes! *** REMEMBER THAT YOU NEED NuGet at: '[tools]/nuget.exe' ***"
      puts " to build nugets."
      puts ""
      puts "Footnote:"
      puts "If you hack a nice task or deployment script - feel free to send a pull request to https://github.com/haf/logirel,"
      puts "to make it available for everyone and get support on it through the community for free!"
      puts ""
    end

    private
    def meta_for p
      puts "META DATA FOR PROJECT: '#{p.name}'"
      title = StrQ.new("Title", p.name).exec
      create_package = BoolQ.new("Package with package manager?").exec
      has_unit_tests = BoolQ.new("Has unit-tests?", false).exec

      {
          :title => title,
          :id => p.name,
          :dir => p.directory,
          :test_dir => if has_unit_tests then StrQ.new("Test Directory", title + ".Tests").exec else "" end,
          :description => StrQ.new("Description", "Missing description for #{p.name}").exec,
          :authors => StrQ.new("Authors", @env.owner, STDIN, lambda { |s| !s.nil? && s.length > 0 }).exec,
          :company => StrQ.new("Company", @env.organization).exec,
          :copyright => StrQ.new("Copyright", "Copyright #{@env.owner}(c)").exec,
          :nuget_key => if create_package then StrQ.new("NuGet key", p.name).exec else "" end,
          :ruby_key => StrQ.new("Ruby key (compulsory: e.g. 'autotx')", nil, STDIN, lambda { |s| s != nil && s.length > 0 }).exec,
          :guid => UUIDTools::UUID.random_create.to_s,
          :dependencies => [],
          :create_package => create_package
      }
    end
  end
end
