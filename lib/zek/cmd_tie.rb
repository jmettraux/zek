
#
# zek/cmd_tie.rb


module Zek::CmdTie; class << self

  def execute(args, lines)

    pu = args[0]
    cu = args[1]

    # TODO pu other self ?

    cpath = Zek.note_path(cu)

    s = File.read(cpath)
    d = Zek.do_index_lines(s.split("\n"))

    if d[:links].assoc('parent')
      s.sub!(/\[parent\]\([^)]+\)/, "[parent](#{pu})")
    else
      s = "\n[parent](#{pu})\n\n" + s
    end

    File.open(cpath, 'wb') { |f| f.write(s) }

    nil
  end

  protected
end; end
