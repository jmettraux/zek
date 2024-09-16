
#
# zek/cmd_root.rb


module Zek::CmdRoot; class << self

  def execute(args, lines)

    ps = Zek.load_index('parents')

    u = Zek.extract_uuid(args.first)
    loop do
      pa = ps[u]
      break unless pa
      u = pa
    end

    puts u
  end

  protected
end; end

