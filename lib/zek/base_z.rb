
#
# zek/base_z.rb

module Zek; module BaseZ; class << self

  ATOZ = ('a'..'z').to_a.join.freeze
  ATOL = ATOZ.length

  def to_int(s)
    i = 0
    b = 1
    s.reverse.each_char do |c|
      p [ c, ATOZ.index(c) ]
      i += b * ATOZ.index(c)
      b *= ATOL
    end
    i
  end

  def to_str(i)
  end
end; end; end

