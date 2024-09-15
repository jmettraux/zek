
#
# zek/cmd_delete.rb


module Zek::CmdDelete; class << self

  def execute(args, lines)

    Zek.note_files(Zek.lookup_uuid(args.first)).each do |path|

      FileUtils.rm_f(path)
    end
  end

  protected
end; end

