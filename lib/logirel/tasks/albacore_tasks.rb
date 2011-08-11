require 'logirel/tasks/core'
%w{
  aspnet
  assembly_info
  aspnet
  msbuild
  ncover
  nuget
  nuspec
  nugetpush
  nunit
  output
  xunit
  zip
}.each{|r| require "logirel/tasks/#{r}"}


