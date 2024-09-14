
#
# zek/cmd_path.rb


module Zek::CmdPath; class << self

  def execute(args, lines)

    puts Zek.note_path(args.first)
  end

  protected
end; end

