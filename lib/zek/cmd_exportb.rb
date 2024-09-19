
#
# zek/cmd_exportb.rb

module Zek::CmdExportb; class << self

  def execute(args, lines)

    selves = Zek.load_selves
    pu = selves['links']
p pu

    fail("Could not find parent [links]") unless pu

    pi = Zek.load_index(pu)
    cn = Zek.load_index('children')
pp pi
pp cn

    nil
  end

  protected
end; end

