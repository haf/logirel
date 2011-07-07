module Logirel::Tasks
  def msbuild_task(sln_file_path = nil, add_as_default = true, opts={})
    #sln_file_path = tuck_and_get :sln_file_path, sln_file_path
    #add_as_default = tuck_and_get :add_as_default, add_as_default

    if add_as_default
      append_to_file File.join(@root, BUILD_FILE), <<-EOF, :verbose => false

  task :default => #{ inject_task_name opts, 'msbuild' }

      EOF
    end

    append_to_file File.join(@root, BUILD_FILE), <<-EOF, :verbose => false

desc "build sln file"
nugetpack #{ inject_task_name opts, 'msbuild' }#{ inject_dependency opts } do |msb|
   msb.solution   = "#{sln_file_path}"
   msb.properties :Configuration => :Debug
   msb.targets    :Clean, :Build
end
    EOF
  end
end
