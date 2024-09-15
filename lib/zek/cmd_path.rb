
#
# zek/cmd_path.rb


module Zek::CmdPath; class << self

  def execute(args, lines)

    puts Zek.note_path(Zek.lookup_uuid(args.first))
  end

  protected
end; end

