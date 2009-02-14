#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'

GITHUB_USERNAME = ARGV[0]

def hasherize(config)
	config_hash = {}
	config.split(/\n/).each do |line|
		key, value = line.split('=')
		config_hash[key] = value
	end
	return config_hash
end

my_gitconfig = hasherize `git config --list`
other_gitconfig = File.open("/tmp/fairpair_#{GITHUB_USERNAME}_gitconfig", 'w')
other_gitconfig.puts(open("http://#{GITHUB_USERNAME}.github.com/config_files/gitconfig").read)
other_gitconfig.close
other_gitconfig = hasherize `git config -f /tmp/fairpair_#{GITHUB_USERNAME}_gitconfig --list`
non_conflicting = other_gitconfig.reject {|key, value| my_gitconfig.has_key?(key)}

non_conflicting.each do |key, value|
	puts "adding #{key}='#{value}' to local gitconfig"
	`git config --add #{key} #{value}`
end
