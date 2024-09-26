
#
# zek/cmd_commit.rb


module Zek::CmdCommit; class << self

  def execute(args, lines)

    if ! File.directory?(Zek.path('.git'))
      puts "Zek repo at #{Zek.repo_path} not a Git"
      exit 1
    end

    dirs = Zek.dpath('*')
      .select { |e| File.directory?(e) }
      .collect { |e| File.basename(e) }
      .select { |e| e.match?(/\A[0-9a-f]{2}\Z/) }
      .join(' ')

    g = "-c color.ui=false"
    m = args.first.to_s

    system(
      "cd #{Zek.repo_path} && " +
      "git #{g} add #{dirs} && " +
      "git #{g} commit -m #{m.inspect}")
  end

  protected
end; end

