Let's try and make a gem to create .Net projects easily.

My thinking
===========

Some problems I want to solve with this project;

 * (bundler/semver/rake/gems)		having foundations for semver, rake for builds and nuget for packaging. 
 * (logirel) 						easily adding structure to a solution folder created with Visual Studio `logirel init`
 * (gitflow)						using ["a successful branching model"](http://nvie.com/posts/a-successful-git-branching-model/)
 * (logirel/teamcity)				continuous integration friendly with 'environments' and transform files for e.g. config files
 * (logirel)						easily updating buildscripts from a git repository 'logirel update', which runs `git pull -s subtree logirel master`.
 * ensuring correct versions of build script dependencies
 * (nuget/owrap/symbolserver.org)	ensuring correct versions of source code dependencies
 * (gitflow)						nicely tagging your source trees corresponding to semver
 * `nuget :nuget do |n|; `git ls-files`.split("\n").each{ |f| n.file f }; end` create a nuget item with just files

TODO list
=========

 1. create gemspec for releases
 1. learn how to unit test ruby and put some fences around my 'release' f-n
 1. build a small interactive prompt; it should set project properties when invoked
 1. specify dependencies with bundler: bundler + bundle, semver, albacore, ruby, rake, nuget
 1. sample configuration settings for team city to build from github
 1. build rake tasks invoking semver with ruby that integrate with teamcity
 1. try the gem out on the transactions, auto tx and nhibernate facility projects
 1. create some guidance - links mostly on how to set up a gemserver locally

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