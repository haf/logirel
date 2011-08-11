module Logirel::Tasks
  def nugetpush_task proj_meta, opts={}

    k = proj_meta[:ruby_key]

    append_to_file BUILD_FILE, <<-EOF, :verbose => false

desc "publishes (pushes) the nuget package '#{proj_meta[:title]}'"
nugetpush #{ inject_task_name opts, k + "_nuget_push" }#{ inject_dependency opts } do |nuget|
  nuget.command = "\#{COMMANDS[:nuget]}"
  nuget.package = "\#{FILES[:#{k}][:nupkg]}"
# nuget.apikey = "...."
  nuget.source = \#{URIS[:nuget_offical]}
  nuget.create_only = false
end

    EOF
  end
end
