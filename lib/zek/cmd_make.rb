
#
# zek/cmd_make.rb

module Zek; class << self

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

  def cmd_make(lines)

    u = Zek.uuid

    title = nil
    parent = nil

    lines.each do |l|

      title ||= l if l.match?(/^\#{1,2} +./)
      parent ||= extract_parent(l)
    end

    title ||= 'none'
      #
    t = title
    t = t[1..-1] while t[0, 1] == '#'
    t = t.strip.downcase.gsub(/[^a-z0-9]/, '_')
    t = t[0, 35] + '_' if t.length > 35

    fn = Zek.uuid_path(u, "n_#{u}_#{t}.md")

    FileUtils.mkdir_p(File.dirname(fn))

    File.open(fn, 'wb') do |f|

      lines.each { |l| f.puts(l) }

      n = Time.now
      f.puts("\n<!-- mtime: #{Zek.long_utc_iso8601_tstamp(n)} #{n} -->")
    end

    [ u, fn ]
  end

  protected

  # beware, it's Zek/self here...
end; end

