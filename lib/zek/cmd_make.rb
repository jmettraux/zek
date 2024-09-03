
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

  MAX_FN_TITLE_LENGTH = 28

  def cmd_make(lines)

    u = Zek.uuid

    x = do_index_lines(lines)

    t = x['title']
    t = t[1..-1] while t[0, 1] == '#'
    t = t.strip.downcase.gsub(/[^a-z0-9]/, '_')
    t = t[0, MAX_FN_TITLE_LENGTH - 1] + '_' if t.length > MAX_FN_TITLE_LENGTH

    fn = Zek.uuid_path(u, "n_#{u}_#{t}.md")

    FileUtils.mkdir_p(File.dirname(fn))

    File.open(fn, 'wb') do |f|

      lines.each { |l| f.puts(l) }

      n = Time.now
      f.puts("\n<!-- mtime: #{Zek.long_utc_iso8601_tstamp(n)} #{n} -->")
    end

    [ u, fn ]
  end

  protected # beware, it's Zek/self here...

  def do_index_lines(lines)

    title = nil
    links = []
    tags = []
    atts = []
    words = []

    lines.each do |l|

      title ||= l.strip if l.match?(/^\#{1,2} +./)
      links += extract_links(l)
      tags += extract_tags(l)
      atts += extract_atts(l)
      words += extract_words(l)
    end

    parent = links.assocv('parent')

puts "---"
    { title: title || 'none',
      links: links.sort_by(&:first),
      atts: atts.sort_by(&:first),
      tags: tags.sort.uniq,
      words: words.sort.uniq }
.tap { |x| pp x }
  end
end; end

