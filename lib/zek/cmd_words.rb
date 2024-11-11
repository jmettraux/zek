
#
# zek/cmd_words.rb


module Zek::CmdWords; class << self

  # FIXME word term_length, etc..., use the (stl -sl) delta...

  def execute(args, lines)

    ws = Zek.load_index('words')
    ss = Zek.load_index('summaries')

    max = ws.map { |w, _| w.term_length }.max + 1

    ws = ws.to_a.reverse if args.include?('r')

    ws.each do |w, is|
      print "#{w}#{' ' * (max - w.term_length)}"; print_node(ss, is[0], max)
      is[1..-1].each { |i| print ' ' * max; print_node(ss, i, max) }
    end
  end

  protected

  def print_node(summaries, uuid, max)

    nd = summaries[uuid]

    s = (
      "/ #{nd[:title]} | #{uuid} #{nd[:size]} #{nd[:lines]}l | #{nd[:line]}"
        ).rstrip

    sl = s.length
    stl = s.term_length
      #
    s = s[0, COLS - max - 1 - (stl - sl)] + '…' \
      if stl > COLS - max

    puts s
  end
end; end

