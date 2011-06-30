root_folder = File.expand_path("#{File.dirname(__FILE__)}/..")

FOLDERS = {
  :root => root_folder,
  :src => "src",
  :out => "build",
  :tests => File.join("build", "tests"),
  :tools => "tools",
  :nunit => File.join("tools", "NUnit", "bin"),

  :packages => "packages",
  :tx_nuspec => File.join("build", "nuspec", Projects[:tx][:dir]),
  :autotx_nuspec => File.join("build", "nuspec", Projects[:autotx][:dir]),
  :nuget => File.join("build", "nuget"),

  :tx_out => 'placeholder - specify build environment',
  :tx_test_out => 'placeholder - specify build environment',
  :autotx_out => 'placeholder - specify build environment',
  :autotx_test_out => 'placeholder - specify build environment',
  :binaries => "placeholder - specify build environment"
}

FILES = {
  :sln => "Castle.Transactions.sln",
  :version => "VERSION",
  :nuget_private_key => "NUGET_KEY",

  :tx => {
    :nuspec => File.join(FOLDERS[:tx_nuspec], "#{Projects[:tx][:id]}.nuspec"),
	:test_log => File.join(FOLDERS[:tests], "Castle.Services.Transaction.Tests.log"),
	:test_xml => File.join(FOLDERS[:tests], "Castle.Services.Transaction.Tests.xml"),

	:test => 'ex: Castle.Services.Transaction.Tests.dll'
  },

  :autotx => {
    :nuspec => File.join(FOLDERS[:autotx_nuspec], "#{Projects[:autotx][:id]}.nuspec"),
	:test_log => File.join(FOLDERS[:tests], "Castle.Facilities.AutoTx.Tests.log"),
	:test_xml => File.join(FOLDERS[:tests], "Castle.Facilities.AutoTx.Tests.xml"),

	:test => 'ex: build/.../Castle.Facilities.AutoTx.Tests.dll'
  }
}

COMMANDS = {
  :nunit => File.join(FOLDERS[:nunit], "nunit-console.exe"),
  :nuget => File.join(FOLDERS[:tools], "NuGet.exe"),
  :ilmerge => File.join(FOLDERS[:tools], "ILMerge.exe")
}

URIS = {
  :nuget_offical => "http://packages.nuget.org/v1/"
}