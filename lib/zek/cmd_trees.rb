
#
# zek/cmd_trees.rb

module Zek::CmdTrees; class << self

  def execute(args, lines)

    d = Zek.load_index('trees')
    d.each do |h, cn|
      p h
      hd = Zek.load_index(h)
      p hd
    end
  end

  protected
end; end

