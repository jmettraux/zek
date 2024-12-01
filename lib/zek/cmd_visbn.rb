
#
# zek/cmd_visbn.rb


module Zek::CmdVisbn; class << self

  def execute(args, lines)

    i = args[0].to_s.gsub(/[^\d]/, '')
    cs = i.chars.map(&:to_i)

    if i.length == 10

      c = cs.pop
      s = cs.each_with_index.inject(0) { |s, (n, i)| s + n * (i + 1) } % 11
      s = (s == 10) ? 'X' : s

      if s == c
        puts "valid ISBN10"
      else
        puts "invalid ISBN10 >#{args[0]}<"
      end

    elsif i.length == 13

      s = cs
        .each_with_index
        .inject(0) { |s, (n, i)| s + n * (i % 2 == 0 ? 1 : 3) }

      if s % 10 == 0
        puts "valid ISBN13"
      else
        puts "invalid ISBN13 >#{args[0]}<"
      end

    else

      puts "not an ISBN >#{args[0]}<"
    end
  end

  protected
end; end

