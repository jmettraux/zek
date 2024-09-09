
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

