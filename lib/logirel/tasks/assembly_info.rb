module Logirel::Tasks
  def assembly_info_task proj_meta, opts={}

    k = proj_meta[:ruby_key]

    append_to_file BUILD_FILE, <<-EOF, :verbose => false

desc 'generate the shared assembly info'
assemblyinfo #{inject_task_name opts, 'assemblyinfo' }#{ inject_dependency opts } do |asm|
  data = commit_data() #hash + date
  asm.product_name = asm.title = PROJECTS[:#{k}][:title]
  asm.description = PROJECTS[:#{k}][:description] + " \#{data[0]} - \#{data[1]}"
  asm.company_name = PROJECTS[:#{k}][:company]
  # This is the version number used by framework during build and at runtime to locate, link and load the assemblies. When you add reference to any assembly in your project, it is this version number which gets embedded.
  asm.version = BUILD_VERSION
  # Assembly File Version : This is the version number given to file as in file system. It is displayed by Windows Explorer. Its never used by .NET framework or runtime for referencing.
  asm.file_version = BUILD_VERSION
  asm.custom_attributes :AssemblyInformationalVersion => "\#{BUILD_VERSION}", # disposed as product version in explorer
    :CLSCompliantAttribute => false,
    :AssemblyConfiguration => "\#{CONFIGURATION}",
    :Guid => PROJECTS[:#{k}][:guid]
  asm.com_visible = false
  asm.copyright = PROJECTS[:#{k}][:copyright]
  asm.output_file = File.join(FOLDERS[:src], 'SharedAssemblyInfo.cs')
  asm.namespaces = "System", "System.Reflection", "System.Runtime.InteropServices", "System.Security"
end

    EOF
  end
end
