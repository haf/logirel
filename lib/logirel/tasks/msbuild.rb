module Logirel::Tasks
  def msbuild_task(add_as_default = true, opts={})

    task_name = inject_task_name opts, 'msbuild'


    append_to_file File.join(@root, BUILD_FILE), <<-EOF, :verbose => false

desc "build sln file"
msbuild #{ task_name }#{ inject_dependency opts } do |msb|
  msb.solution   = FILES[:sln]
  msb.properties :Configuration => CONFIGURATION
  msb.targets    :Clean, :Build
end
    EOF
  end
end
