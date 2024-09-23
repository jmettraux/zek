
#
# zek/cmd_mkdirp.rb


module Zek::CmdMkdirp; class << self

  def execute(args, lines)

    FileUtils.mkdir_p(Zek.uuid_to_path(args.first))
  end

  protected
end; end

