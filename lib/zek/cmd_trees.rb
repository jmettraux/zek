
#
# zek/cmd_trees.rb

module Zek; class << self

  def cmd_trees(args, lines)

    d = load_index('trees')
    d.each do |h, cn|
      p h
      hd = load_index(h)
      p hd
    end
  end

  protected # beware, it's Zek/self here...
end; end

