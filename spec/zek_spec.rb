
#
# Specifying zek
#
# Wed Aug 28 09:15:01 JST 2024  The Board Room
#

require 'spec_helper'


describe Zek do

  describe '_uuid' do

    it 'returns a string UUID' do

      expect(Zek._uuid(1724973791.49255)
        ).to match(/^0191a07339047[a-z0-9]{19}$/)
    end

    it 'avoids collisions' do

      t = Time.now
      us = []
      n = 1_000_000
      n.times { us << Zek._uuid(t) }

      expect(us.count).to eq(n)
      expect(us.uniq.count).to eq(n)
    end
  end

  describe 'uuid' do

    it 'returns a string UUID' do

      expect(Zek.uuid).to match(/^[0-9a-z]{32}$/)
    end

    it 'avoids collisions' do

      us = []
      n = 1_000
      n.times { us << Zek.uuid }

      expect(us.count).to eq(n)
      expect(us.uniq.count).to eq(n)

      # could be better...
      # and it does not test file checking...
    end
  end

  describe 'uuid_to_path()' do

    {

      '01919658a6ac715b951cd094dd489d48' => '48/9d',
      '0191973cc9437110939d4f5ac9432a4d' => '4d/2a',

    }.each do |k, v|

      it "returns #{v.inspect} for #{k}" do

        expect(Zek.uuid_to_path(k)).to eq(Zek.path(v))
      end
    end

    it 'joins path elements' do

      u = Zek._uuid
      s = Zek.uuid_to_path(u, "n_#{u}_*.md")

      expect(s.split('/').last).to match(/^n_#{u}_\*\.md$/)
    end
  end

  describe 'extract_uuid()' do

    {

      'n_01919658a6ac715b951cd094dd489d48_foobar' =>
        '01919658a6ac715b951cd094dd489d48',
      'i_0191973cc9437110939d4f5ac9432a4d_toto.png' =>
        '0191973cc9437110939d4f5ac9432a4d',
      '#0191973cc9437110939d4f5ac9432a4d' =>
        '0191973cc9437110939d4f5ac9432a4d',

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

  describe 'uuid_to_time()' do

    {

      '01919658a6ac715b951cd094dd489d48' => 1724804277,
      '01919b3ec78679f3bda68a1b6432b58d' => 1724886468,
      '01919b3ed2f7721f97f3dfbd0acfed57' => 1724886471,

    }.each do |k, v|

      it "returns #{v} for #{k.inspect}" do

        expect(Zek.uuid_to_time(k).to_i).to eq(v)
      end
    end
  end

  describe 'extract_links()' do

    {

      "nada" => [
        ],
      "[parent](#1234)" => [
        [ 'parent', '#1234' ] ],
      "[self](#1234) and [toto](https://example.org)" => [
        [ 'self', '#1234' ], [ 'toto', 'https://example.org' ] ],
      "[toto](https://example.org) vs [parent](#3456e)" => [
        [ 'toto', 'https://example.org' ], [ 'parent', '#3456e' ] ],

    }.each do |k, v|

      it "returns #{v.inspect} for #{k.inspect}" do

        expect(Zek.extract_links(k)).to eq(v)
      end
    end
  end

#  describe 'extract_parent()' do
#    {
#
#      "nada" => nil,
#      "[parent](#1234)" => '#1234',
#      "[self](#1234) and [toto](https://example.org)" => nil,
#      "[toto](https://example.org) vs [parent](#3456e)" => '#3456e',
#
#    }.each do |k, v|
#
#      it "returns #{v.inspect} for #{k.inspect}" do
#
#        expect(Zek.extract_parent(k)).to eq(v)
#      end
#    end
#  end
  describe 'is_uuid?()' do

    {

      '01919658a6ac715b951cd094dd489d48' => true,
      '#01919658a6ac715b951cd094dd489d48' => true,

      'toto' => false,
      '#01919' => false,
      123 => false,
      nil => false,

    }.each do |k, v|

      it "returns #{v} for #{k.inspect}" do

        expect(Zek.is_uuid?(k)).to eq(v)
      end
    end
  end
end

