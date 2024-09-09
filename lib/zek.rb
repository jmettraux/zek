
#
# lib/zek.rb

require 'time'
require 'yaml'
require 'fileutils'
require 'securerandom'


$: << __dir__ unless $:.include?(__dir__)

require 'zek/_extensions'
require 'zek/base_z'
require 'zek/zek'

Dir[File.join(__dir__, 'zek', 'cmd_*.rb')].each { |pa| require(pa) }


if __FILE__ == $0

  args = ARGV.dup
  cmd = args.find { |a| a[0, 1] != '-' }
  args.delete(cmd) if cmd

  lines = STDIN.tty? ? [] : STDIN.readlines

  cmd ||= lines.shift
  cmd = cmd.strip.match(/^([_a-z][_a-z0-9]+)/)[1]

  Zek.send("cmd_#{cmd}", args, lines)
end

