
#
# zek/cmd_words.rb


module Zek::CmdWords; class << self

  def execute(args, lines)

    ws = Zek.load_index('words')
    ss = Zek.load_index('summaries')

    ws = ws.to_a.reverse if args.include?('r')

    ws.each do |w, is|
      puts "## #{w}:"
      is.each { |i| print_node(ss, i) }
      puts
    end
  end

  protected

  def print_node(summaries, uuid)

    nd = summaries[uuid]

    s = (
      #'  ' +
      "/ #{nd[:title]} | #{uuid} #{nd[:size]} #{nd[:lines]}l | #{nd[:line]}"
        ).rstrip

    sl = s.length
    stl = s.term_length
      #
    s = s[0, COLS - 1 - (stl - sl)] + '…' \
      if stl > COLS

    puts s
  end
end; end

