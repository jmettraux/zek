
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
end

