module Logirel::Tasks
  def nuspec_task proj_meta, opts={}

    k = proj_meta[:ruby_key]

    append_to_file BUILD_FILE, <<-EOF, :verbose => false
nuspec #{inject_task_name opts, k + "_nuspec"}#{ inject_dependency opts } do |nuspec|
  nuspec.id = "\#{PROJECTS[:#{k}][:nuget_key]}"
  nuspec.version = BUILD_VERSION
  nuspec.authors = "\#{PROJECTS[:#{k}][:authors]}"
  nuspec.description = "\#{PROJECTS[:#{k}][:description]}"
  nuspec.title = "\#{PROJECTS[:#{k}][:title]}"
  # nuspec.projectUrl = 'http://github.com/haf' # TODO: Set this for nuget generation
  nuspec.language = "en-US"
  nuspec.licenseUrl = "http://www.apache.org/licenses/LICENSE-2.0" # TODO: set this for nuget generation
  nuspec.requireLicenseAcceptance = "false"
  #{proj_meta.
    dependencies.
    collect{|dep| "  nuspec.dependency '#{dep[:nuget_key]}', '#{dep[:version]}'" }.
    join("\n") unless proj_meta.dependencies.empty?
  }

  nuspec.output_file = FILES[#{k}][:nuspec]

  add_files "\#{PROJECTS[:#{k}][:id]}.{dll,pdb,xml}", nuspec
end
EOF
  end
end