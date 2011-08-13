Let's try and make a gem to create .Net projects easily.

Getting started
===============
 1. `gem install logirel`
 1. Go to the project of your choice
 1. `logirel`
 1. You should now answer the questions that logirel poses.
 1. after it's done, run `rake`.

**[Apache 2 Licensed](http://www.apache.org/licenses/LICENSE-2.0.html)**
 
Hacking it
==========
 1. `git clone https://haf@github.com/haf/logirel.git`
 1. `bundle install`
 1. hack it.

My thinking
===========

Some problems I want to solve with this project;

 * (bundler/semver/rake/gems)		having foundations for semver, rake for builds and nuget for packaging. 
 * (logirel) 						easily adding structure to a solution folder created with Visual Studio `logirel init`
 * (gitflow)						using ["a successful branching model"](http://nvie.com/posts/a-successful-git-branching-model/)
 * (logirel/teamcity)				continuous integration friendly with 'environments' and transform files for e.g. config files
 * (logirel)						easily updating buildscripts from a git repository `gem update ; logirel update`
 * ensuring correct versions of build script dependencies
 * (nuget/owrap/symbolserver.org)	ensuring correct versions of source code dependencies
 * (gitflow)						nicely tagging your source trees corresponding to semver
 * `nuget :nuget do |n|; 'git ls-files'.split("\n").each{ |f| n.file f }; end` create a nuget item with just files

TODO list
=========

 1. sample configuration settings for team city to build from github
 1. try the gem out on the transactions, auto tx and nhibernate facility projects
 1. for those projects where we don't want to gen nupkg, don't ask for nuget key
 1. ask for current version when initing semver
 1. don't gen test_out for projects with no tests
 1. use a loop for setting output directories in :set_dirs in environment.tt, like it is :dir_tasks
 1. generating nugets:
   2. icon
   2. project url
   2. summary
   2. asking for framework dependencies
   2. asking for ordinary dependencies
   2. require license acceptance

A note about aims
=================

The aim is **not** to replace nuget nor owrap. This is will principally be a gem for setting up a great
rakefile and versioning the package through rake and continuous integration and publishing the artifacts.

Nuget and OpenWrap don't integrate with continuous integration environments. They don't assist in creating
a nice build environment. With them, it's up to yourself to implement a build script that follows semantic
versioning.

Often I encounter .Net open source projects that I want to use. Because I'm increasingly writing SOA code
where each service is on its own, communicating through events/EDA and commands, I need to quickly
be able to set up a build environment for those projects and make sure I can version the dependencies
properly. Right now, hacking build scripts, is taking too much time. For example, it should be very
easy to create .Sample projects for nuget, so that people can learn about my frameworks, but the overhead
of managing another build is too large.

Shoulders of Giants
===================
 * http://madduck.net/blog/2007.07.11:creating-a-git-branch-without-ancestry/
 * http://rubydoc.info/github/wycats/thor/master/file/README.md
 * https://github.com/radar/guides/blob/master/gem-development.md
 * http://eggsonbread.com/2010/03/28/my-rspec-best-practices-and-tips/
 * https://github.com/jondot/albathor (I actually started work on this one, before I saw this project; none the less
   I've integrated pieces of its functionality into logirel, mostly its actions module and vs proj parsing.)