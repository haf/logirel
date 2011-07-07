require 'logirel/tasks/core'
%w{
  aspnet
  assembly_info
  aspnet
  msbuild
  ncover
  nuget
  nuspec
  nunit
  output
  xunit
  zip
}.each{|r| require "logirel/tasks/#{r}"}


