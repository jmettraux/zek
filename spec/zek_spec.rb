
#
# Specifying zek
#
# Wed Aug 28 09:15:01 JST 2024  The Board Room
#

require 'spec_helper'


describe Zek do

  describe 'uuid_to_path()' do

    {

      "01919658a6ac715b951cd094dd489d48" =>
        "48/9d/01919658a6ac715b951cd094dd489d48",

    }.each do |k, v|

      it "returns #{v.inspect} for #{k}" do

        expect(Zek.uuid_to_path(k)).to eq(v)
      end
    end
  end
end

