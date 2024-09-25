
#
# zek/cmd_self.rb


module Zek::CmdSelf; class << self

  def execute(args, lines)

    u = args.first
    puts Zek.load_selves[u] || u
  end

  protected
end; end

