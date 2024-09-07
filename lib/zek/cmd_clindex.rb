
#
# zek/cmd_clindex.rb

module Zek; class << self

  def cmd_clindex(lines)

    Zek.paths('*.i.*').each do |path|

      FileUtils.rm_f(path)
      puts ". rm #{path}"
    end
  end

  protected # beware, it's Zek/self here...
end; end

