#!/usr/bin/env ruby
require 'find'

class WatchedFile
  def initialize(path)
    @path = path
    refresh
  end

  def refresh
    @last_modified = File.mtime(@path)
  end

  def hasChanged?
    @last_modified != File.mtime(@path)
  end

  def path
    return @path
  end

  def to_s
    return "#{@path} - #{@last_modified}"
  end
end

tap_program = 'cat'
path = "./"
tap_rate = 0.5
use_heartbeat = true

WatchList = []
Find.find(path) do |f| WatchList << WatchedFile.new(f) end

def FindChangedFiles()

  # files can be and removed
  # don't check for now

  modifiedList = []
  WatchList.each do |f|

    if f.hasChanged? then
      modifiedList << f.path
      f.refresh()
    end

  end

  return modifiedList
end

while true do
  sleep(tap_rate)

  changedFiles = FindChangedFiles()
  didFilesChange = changedFiles.count >0
  if use_heartbeat or didFilesChange then

    if didFilesChange then
      puts "#{changedFiles.count}"
    end

    flattened = changedFiles.map { |s| "'#{s}'" }.join(' ')
    puts "#{tap_program} #{path} #{flattened}"
  end
end