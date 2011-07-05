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
end
