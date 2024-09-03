
#
# lib/zek.rb

require 'time'
require 'yaml'
require 'fileutils'
require 'securerandom'


$: << __dir__ unless $:.include?(__dir__)

require 'zek/_extensions'
require 'zek/zek'

Dir[File.join(__dir__, 'zek', 'cmd_*.rb')].each { |pa| require(pa) }


if __FILE__ == $0

  cmd, *lines = STDIN.readlines
  cmd = cmd.strip.match(/^([_a-z][_a-z0-9]+)/)[1]

  Zek.send("cmd_#{cmd}", lines)
end

