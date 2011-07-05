require "#{folders[:buildscripts]}/paths"
require 'semver'

namespace :env do

  task :common do
    # version management
    fv = version SemVer.find.to_s
    revision = (!fv[3] || fv[3] == 0) ? (ENV['BUILD_NUMBER'] || Time.now.strftime('%j%H')) : fv[3] #  (day of year 0-265)(hour 00-24)

    ENV['BUILD_VERSION'] = BUILD_VERSION = SemVer.new(fv[0], fv[1], fv[2], revision).to_s
    puts "Assembly Version: #{BUILD_VERSION}."
    puts "##teamcity[buildNumber '#{BUILD_VERSION}']" # tell teamcity our decision

    # .net/mono configuration management
    ENV['FRAMEWORK'] = FRAMEWORK = ENV['FRAMEWORK'] || (Rake::Win32::windows? ? "net40" : "mono28")
    puts "Framework: #{FRAMEWORK}"
  end

  # configure the output directories
  task :configure, [:str] do |_, args|
    ENV['CONFIGURATION'] = CONFIGURATION = args[:str]
    FOLDERS[:binaries] = File.join(FOLDERS[:out], FRAMEWORK, args[:str].downcase)
    CLEAN.include(File.join(FOLDERS[:binaries], "*"))
  end

  task :set_dirs do
    FOLDERS[:proj_out] = File.join(FOLDERS[:src], Projects[:proj][:dir], 'bin', CONFIGURATION)
    CLEAN.include(FOLDERS[:proj_out])

    # for tests
    FOLDERS[:proj] = File.join(FOLDERS[:src], Projects[:proj][:test_dir], 'bin', CONFIGURATION)
    FILES[:proj][:test] = File.join(FOLDERS[:proj_test_out], "#{Projects[:proj][:test_dir]}.dll")
    CLEAN.include(FOLDERS[:proj_test_out])
  end

  desc "set debug environment variables"
  task :debug => [:common] do
    Rake::Task["env:configure"].invoke('Debug')
    Rake::Task["env:set_dirs"].invoke
  end

  desc "set release environment variables"
  task :release => [:common] do
    Rake::Task["env:configure"].invoke('Release')
    Rake::Task["env:set_dirs"].invoke
  end

  desc "set GA envionment variables"
  task :ga do
    puts "##teamcity[progressMessage 'Setting environment variables for GA']"
    ENV['OFFICIAL_RELEASE'] = OFFICIAL_RELEASE = "4000"
  end

  desc "set release candidate environment variables"
  task :rc, [:number] do |t, args|
    puts "##teamcity[progressMessage 'Setting environment variables for Release Candidate']"
    arg_num = args[:number].to_i
    num = arg_num != 0 ? arg_num : 1
    ENV['OFFICIAL_RELEASE'] = OFFICIAL_RELEASE = "#{3000 + num}"
  end

  desc "set beta-environment variables"
  task :beta, [:number] do |t, args|
    puts "##teamcity[progressMessage 'Setting environment variables for Beta']"
    arg_num = args[:number].to_i
    num = arg_num != 0 ? arg_num : 1
    ENV['OFFICIAL_RELEASE'] = OFFICIAL_RELEASE = "#{2000 + num}"
  end

  desc "set alpha environment variables"
  task :alpha, [:number] do |t, args|
    puts "##teamcity[progressMessage 'Setting environment variables for Alpha']"
    arg_num = args[:number].to_i
    num = arg_num != 0 ? arg_num : 1

    ENV['BUILD_VERSION_INFORMAL'] = BUILD_VERSION_INFORMAL =
    ENV['OFFICIAL_RELEASE'] = OFFICIAL_RELEASE = "#{1000 + num}"
  end
end
