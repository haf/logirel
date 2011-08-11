module Logirel::Tasks
  def msbuild_task(add_as_default = true, opts={})
    #sln_file_path = tuck_and_get :sln_file_path, sln_file_path
    #add_as_default = tuck_and_get :add_as_default, add_as_default

    task_name = inject_task_name opts, 'msbuild'

    if add_as_default
      append_to_file File.join(@root, BUILD_FILE), "task :default #{ inject_dependency opts, [task_name] }"
    end

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
