
#
# Specifying zek
#
# Wed Aug 28 09:15:01 JST 2024  The Board Room
#

require 'spec_helper'


describe Zek do

  describe 'uuid_to_path()' do

    {

      "01919658a6ac715b951cd094dd489d48" => "48/9d",
      "0191973cc9437110939d4f5ac9432a4d" => "4d/2a",

    }.each do |k, v|

      it "returns #{v.inspect} for #{k}" do

        expect(Zek.uuid_to_path(k)).to eq(Zek.path(v))
      end
    end
  end

  describe 'extract_uuid()' do

    {

      "n_01919658a6ac715b951cd094dd489d48_foobar" =>
        "01919658a6ac715b951cd094dd489d48",
      "i_0191973cc9437110939d4f5ac9432a4d_toto.png" =>
        "0191973cc9437110939d4f5ac9432a4d",

      nil => nil,
      123 => nil,
      'nada' => nil,
      [] => nil,

    }.each do |k, v|

      it "returns #{v.inspect} for #{k}" do

        expect(Zek.extract_uuid(k)).to eq(v)
      end
    end
  end
end
