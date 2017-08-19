# Tapper
A simple command line program that monitors a directory for changed files and takes an action.

## Settings File

Simple yaml file.

-- Heart Beat means the update runs every X seconds even if there's no change.
use_heartbeat = true
-- Run check every 0.5 seconds, if `use_heartbeat` is true then run the program even if there are no changes
tap_rate = 0.5
-- Recursively monitors all files in this directory for changes
monitor_dir = './'
-- The program to run every change. If it fails to run then an error message is displayed
-- Passes through two command line args
-- 1. Monitor Dir
-- 2. List of changed files
tap_program = './some_program'

