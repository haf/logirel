require 'construct'

def with_sample_projects(&block)
  Construct::within_construct do |c|	
    # given files	
    c.directory('src/A')
    c.directory('src/B')
    c.directory('src/C')
    c.file('src/A/A.csproj') do |f|
      f.puts "cs proj file ... xml in here"
    end
    
    c.file('src/C/HelloWorld.vbproj')
	block.call(c)
  end
end

def abc_projects(in_folder)
  puts "creating projects A, B and C in #{in_folder}"

  src = File.join(in_folder, "src")
  if Dir.exists?(src) 
    return
  end
  Dir.mkdir(src)
  Dir.mkdir(File.join(in_folder, 'src/A'))
  File.new(File.join(in_folder, 'src/A/A.csproj'), "w") do |f|
    f.puts "cs proj file ... xml in here"
  end
  Dir.mkdir(File.join(in_folder, 'src/B'))
  Dir.mkdir(File.join(in_folder, 'src/C'))
  File.new(File.join(in_folder, 'src/C/HelloWorld.vbproj'), "w") do |f|
    f.puts "vb-things"
  end
end