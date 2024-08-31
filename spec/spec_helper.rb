
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

  c.around(:example, :repo) do |ex|

    dirs0 = Dir[Zek.path('*')]

    ex.run

    Dir[Zek.path('*')].each do |dir|
      FileUtils.rm_rf(dir) unless dirs0.include?(dir)
    end
  end

  c.alias_example_to(:they)
  c.alias_example_to(:so)
  c.include(Helpers)
end


class String

  def hstrip

    #self.gsub(/^\s*/, '').gsub(/\s*$/, '').strip
    split("\n").collect(&:strip).join("\n").strip
  end
  alias htrip hstrip
end

