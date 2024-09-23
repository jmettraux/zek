
#
# zek/cmd_uuidp.rb


module Zek::CmdUuidp; class << self

  def execute(args, lines)

    u = Zek.uuid
    puts Zek.uuid_to_path(u, u)
  end

  protected
end; end

