#!/usr/bin/env ruby
require 'find'
require 'yaml'

settings = YAML.load_file("./settings.yaml")
use_heartbeat = false
if settings.key?("use_heartbeat") then
  use_heartbeat = settings["use_heartbeat"]
end

tap_program = 'echo'
if settings.key?("tap_program") then
  tap_program = settings['tap_program']
end

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

path = "./"
tap_rate = 0.5

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
      puts "Files changed: #{changedFiles.count}"
    end

    flattened = changedFiles.map { |s| "'#{s}'" }.join(' ')
    puts `#{tap_program} #{path} #{flattened}`
  end
end