
#
# zek/_extensions.rb

class Array

  def assocv(k)

    k, v = assoc(k)

    k ? v : nil
  end
end

