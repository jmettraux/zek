
#
# Specifying zek
#
# Tue Aug 27 15:16:10 JST 2024 The Board Room
#

#require 'pp'
#require 'ostruct'

require 'zek'


module Helpers

  def monow; Process.clock_gettime(Process::CLOCK_MONOTONIC); end
end # Helpers

RSpec.configure do |c|

  c.alias_example_to(:they)
  c.alias_example_to(:so)
  c.include(Helpers)
end

