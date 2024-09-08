
#
# zek/cmd_import.rb

module Zek; class << self

  def cmd_import(args, lines)

    from_dir = args.shift

    Dir[File.join(from_dir, '*.md')].each do |path|

      u, fn, x = Zek.cmd_make(args, File.readlines(path))

      x[:attcs].each { |a| attach(path, u, fn, a) }
    end
  end

  protected # beware, it's Zek/self here...

  def attach(path, u, fn, a)
    path0 = File.join(File.dirname(path), a)
    path1 = File.join(File.dirname(fn), "#{u}_#{File.basename(a)}")
    FileUtils.cp(path0, path1)
  end
end; end

