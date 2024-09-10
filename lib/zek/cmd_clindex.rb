
#
# zek/cmd_clindex.rb

module Zek::CmdClindex; class << self

  def execute(args, lines)

    Zek.paths('*.i.*').each do |path|

      FileUtils.rm_f(path)
      puts ". rm #{path}"
    end
  end

  protected
end; end

