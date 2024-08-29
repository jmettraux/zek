
#
# lib/zek.rb

require 'securerandom'
require 'time'

require 'zek/zek'


module Zek

  class << self

    def cmd_make(lines)

      p [ :make, lines ]
    end
  end
end


if __FILE__ == $0

  cmd, *lines = STDIN.readlines
  cmd = cmd.strip.match(/^([_a-z][_a-z0-9]+)/)[1]

  Zek.send("cmd_#{cmd}", lines)
end

