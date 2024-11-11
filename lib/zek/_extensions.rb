
#
# zek/_extensions.rb

class Array

  def assocv(k)

    k, v = assoc(k)

    k ? v : nil
  end
end

class String

  def path_split

    split('/')
  end
  alias psplit path_split
  alias splip path_split

  def without_extname

    i = rindex('.')
    i ? self[0..i - 1] : self
  end
  alias without_ext without_extname
  alias wo_extname without_extname
  alias wo_ext without_extname

  def hstrip

    #self.gsub(/^\s*/, '').gsub(/\s*$/, '').strip
    self.split("\n").collect(&:strip).join("\n").strip
  end
  alias htrip hstrip

  def term_length

    chars
      .inject(0) { |r, c|
        c.match?(/[\p{Han}\p{Hiragana}\p{Katakana}]/) ? r + 2 :
        r + 1 }
  end

  #def extra_length
  #  chars.inject(0) { |r, c| c.match?(/\p{Han}/) ? r + 1 : r }
  #end
end

