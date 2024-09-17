
[self](base_z)

:code :ruby


## Base Z

Could have been helpful in flor.

```ruby
#
# zek/base_z.rb

module Zek; module BaseZ; class << self

  CHARS = 'oabcdefghi'.freeze

  def to_int(s)
    i = 0
    b = 1
    s.reverse.each_char do |c|
      i += b * CHARS.index(c)
      b *= 10
    end
    i
  rescue
    raise ArgumentError.new("#{s.inspect} is not in Zek::BaseZ")
  end

  def to_str(i)

    i.to_s.each_char.inject([]) { |a, c| a << CHARS[c.to_i]; a }.join
  end

  def succ(s)

    to_str(to_int(s) + 1)
  end
end; end; end
```

And here are the specs:

```ruby
#
# Specifying zek
#
# Mon Sep  9 09:10:50 JST 2024
#

require 'spec_helper'


describe Zek::BaseZ do

  describe 'to_str(i)' do

    { 1 => 'a',
      2 => 'b',
      9 => 'i',
      0 => 'o',
      10 => 'ao',
      90 => 'io',
      211 => 'baa',
    }.each do |k, v|

      it "returns #{v.inspect} for #{k.inspect}" do

        expect(Zek::BaseZ.to_str(k)).to eq(v)
      end
    end
  end

  describe 'to_int(s)' do

    { 'a' => 1,
      'b' => 2,
      'i' => 9,
      'o' => 0,
      'oi' => 9,
      'ao' => 10,
      'io' => 90,
      'baa' => 211,

    }.each do |k, v|

      it "returns #{v.inspect} for #{k.inspect}" do

        expect(Zek::BaseZ.to_int(k)).to eq(v)
      end
    end
  end

  describe 'succ(s)' do

    { 'a' => 'b',
      'b' => 'c',
      'i' => 'ao',
      'o' => 'a',
      'oi' => 'ao',
      'ao' => 'aa',
      'io' => 'ia',
      'baa' => 'bab',

    }.each do |k, v|

      it "returns #{v.inspect} for #{k.inspect}" do

        expect(Zek::BaseZ.succ(k)).to eq(v)
      end
    end
  end
end
```

That's all folks.

