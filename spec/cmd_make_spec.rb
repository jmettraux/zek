
#
# Specifying zek
#
# Sat Aug 31 09:55:58 JST 2024
#

require 'spec_helper'


describe Zek, :repo do

  describe 'cmd_make()' do

    it 'writes the note to the repo' do

      lines = %{
        [parent](#123123123)

        # hello world

        an extensive review of carrier capability.
      }.htrip.split(/\n/)

      u, fn = Zek::CmdMake.execute([], lines)

      s = File.read(fn)
      ls = s.split("\n")

      expect(s).to match(/ mtime: 20/)
      expect(ls[0]).to eq('[parent](#123123123)')
    end
  end
end

