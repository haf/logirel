module Logirel::Tasks
  def output_task proj_meta, opts={}

    k = proj_meta[:ruby_key]

    append_to_file BUILD_FILE, <<-EOF, :verbose => false

task #{inject_task_name opts, k + "_output"}#{ inject_dependency opts } do
  target = File.join(FOLDERS[:binaries], PROJECTS[:#{k}][:id])
  copy_files FOLDERS[:#{k}][:out], "*.{xml,dll,pdb,config}", target
  CLEAN.include(target)
end

EOF
  end
end
