
#
# zek/cmd_trees.rb


module Zek::CmdTrees; class << self

  def execute(args, lines)

    ts = Zek.load_index('trees')
    ss = Zek.load_index('summaries')

    ts.each do |n|
      print_node(ss, n, 0)
    end
  end

  protected

  def print_node(summaries, node, depth)

    nd = summaries[node[0]]

    s = (
      '  ' * depth +
      "/ #{nd[:title]} | #{node[0]} #{nd[:size]} #{nd[:lines]}l | #{nd[:line]}"
        ).rstrip

    s = s[0, COLS - 1] + '…' if s.length > COLS

    puts s

    node[2].each do |cn|
      print_node(summaries, cn, depth + 1)
    end
  end
end; end

