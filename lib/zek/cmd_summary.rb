
#
# zek/cmd_summary.rb

module Zek::CmdSummary; class << self

  def execute(args, lines)

    # TODO
    #
    # [ ] list selves that are used more than once
    # [ ] enumerate trees

    trees = load_index('trees')
pp trees

    #Zek.paths('*.i.*').each do |path|
    #  FileUtils.rm_f(path)
    #  puts ". rm #{path}"
    #end
  end

  protected
end; end

