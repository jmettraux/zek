
#
# zek/cmd_make.rb

module Zek::CmdMake; class << self

%{
[parent](#019190ef87437aea9bd426d424fb4709)

## "One Day in the Life of Ivan Denisovich"

[self](#01919101182776a18709137411c3ec49) :literature :book

Ivan Denisovich Shukhov is the protagonist of the novel "One Day in the Life of
Ivan Denisovich" by Russian author Aleksandr Solzhenitsyn. The novel, published
in 1962, describes a single day of an ordinary prisoner in a Soviet labor camp
in the 1950s. Shukhov is a former POW from World War II who was sentenced to a
labor camp for being accused of spying after his capture by the Germans. The
novel explores his daily life and survival in the harsh conditions of the camp.

<!-- status: archived -->
<!-- mtime: Tue Aug 27 14:58:01 JST 2024 -->
<!-- source: Telegram -->
}

  MAX_FN_TITLE_LENGTH = 28

  def execute(args, lines)

    u = Zek.uuid

    x = Zek.do_index_lines(lines)

    t = x[:title]
    t = t[1..-1] while t[0, 1] == '#'
    t = t.strip.downcase.gsub(/[^a-z0-9]/, '_')
    t = t[0, MAX_FN_TITLE_LENGTH - 1] + '_' if t.length > MAX_FN_TITLE_LENGTH

    fn = Zek.uuid_path(u, "#{u}_#{t}.md")

    FileUtils.mkdir_p(File.dirname(fn))

    File.open(fn, 'wb') do |f|

      lines.each { |l| f.puts(l) }

      n = Time.now
      f.puts("\n<!-- mtime: #{Zek.long_utc_iso8601_tstamp(n)} #{n} -->")
    end

    Zek::CmdIndex.execute(args, nil) \
      unless args.include?(:import) || args.include?(:noindex)

    puts u

    [ u, fn, x ]
  end

  protected
end; end

