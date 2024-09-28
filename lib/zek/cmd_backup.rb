
#
# zek/cmd_backup.rb


module Zek::CmdBackup; class << self

  def execute(args, lines)

    system("cd #{Zek.repo_path} && make bak")
  end

  protected
end; end

