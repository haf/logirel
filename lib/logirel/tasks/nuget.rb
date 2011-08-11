module Logirel::Tasks
  def nuget_task(proj_meta, opts={})

    k = proj_meta[:ruby_key]

    append_to_file BUILD_FILE, <<-EOF, :verbose => false

desc "nuget pack '#{proj_meta[:title]}'"
nugetpack #{ inject_task_name opts, k + "_nuget" }#{ inject_dependency opts } do |nuget|
   nuget.command     = "\#{COMMANDS[:nuget]}"
   nuget.nuspec      = "\#{FILES[:#{k}][:nuspec]}"
   # nuget.base_folder = "."
   nuget.output      = "\#{FOLDERS[:nuget]}"
end

    EOF
  end
end
