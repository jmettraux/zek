
#
# zek/cmd_uui.rb


module Zek::CmdUui; class << self

  def execute(args, lines)

    puts Zek.find_uuid(args.first)
  end

  protected
end; end

