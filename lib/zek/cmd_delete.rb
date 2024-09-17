
#
# zek/cmd_delete.rb


module Zek::CmdDelete; class << self

  def execute(args, lines)

    Zek.note_files(Zek.lookup_uuid(args.first)).each do |path|

      if File.extname(path) == '.md'
        File.open(path, 'ab') { |f| f.write("\n<!-- status: deleted -->\n") }
      else
        FileUtils.rm_f(path)
      end
    end
  end

  protected
end; end

