
#
# Specifying zek
#
# Mon Sep  9 09:10:50 JST 2024
#

require 'spec_helper'


describe Zek::BaseZ do

  describe 'to_str(i)' do

    {

      0 => 'a',

    }.each do |k, v|

      it "returns #{v.inspect} for #{k.inspect}" do

        expect(Zek::BaseZ.to_str(k)).to eq(v)
      end
    end
  end

  describe 'to_int(s)' do

    {

      'a' => 0,
      'b' => 1,
      'z' => 25,
      'ba' => 26,
      'bb' => 27,
      'baa' => 676,

    }.each do |k, v|

      it "returns #{v.inspect} for #{k.inspect}" do

        expect(Zek::BaseZ.to_int(k)).to eq(v)
      end
    end
  end
end
