
#
# zek/cmd_import.rb

module Zek::CmdImport; class << self

  def execute(args, lines)

    from_dir = args.shift
    args << :import

    Dir[File.join(from_dir, '*.md')].each do |path|

      u, fn, x = Zek::CmdMake.execute(args, File.readlines(path))

      x[:attcs].each { |a| attach(path, u, fn, a) }
    end
  end

  protected

  def attach(path, u, fn, a)

    path0 = File.join(File.dirname(path), a)
    path1 = File.join(File.dirname(fn), "#{u}_#{File.basename(a)}")

    FileUtils.cp(path0, path1)
  end
end; end

