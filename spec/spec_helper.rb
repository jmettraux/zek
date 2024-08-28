
#
# Specifying zek
#
# Tue Aug 27 15:16:10 JST 2024 The Board Room
#

#require 'pp'
#require 'ostruct'

require 'zek'

ENV['ZEK_REPO_PATH'] = File.join(File.dirname(__FILE__), 'repo')


module Helpers
end # Helpers

RSpec.configure do |c|

  c.alias_example_to(:they)
  c.alias_example_to(:so)
  c.include(Helpers)
end

