
#
# zek/cmd_summary.rb

module Zek; class << self

  def cmd_summary(args, lines)

    # TODO
    #
    # [ ] list selves that are used more than once
    # [ ] enumerate trees

    trees = load_index('index/trees')
pp trees

    #Zek.paths('*.i.*').each do |path|
    #  FileUtils.rm_f(path)
    #  puts ". rm #{path}"
    #end
  end

  protected # beware, it's Zek/self here...
end; end

