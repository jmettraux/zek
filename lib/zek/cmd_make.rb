
#
# zek/cmd_make.rb

module Zek; class << self

# [parent](#019190ef87437aea9bd426d424fb4709)
#
# ## "One Day in the Life of Ivan Denisovich"
#
# [self](#01919101182776a18709137411c3ec49) :literature :book
#
# Ivan Denisovich Shukhov is the protagonist of the novel "One Day in the Life of
# Ivan Denisovich" by Russian author Aleksandr Solzhenitsyn. The novel, published
# in 1962, describes a single day of an ordinary prisoner in a Soviet labor camp
# in the 1950s. Shukhov is a former POW from World War II who was sentenced to a
# labor camp for being accused of spying after his capture by the Germans. The
# novel explores his daily life and survival in the harsh conditions of the camp.
#
# <!-- status: archived -->
# <!-- mtime: Tue Aug 27 14:58:01 JST 2024 -->
# <!-- source: Telegram -->

  def cmd_make(lines)

    id = Zek.uuid

    title = nil
    parent = nil

    lines.each do |l|

      m = false #l.match(/^#{1,2} +./)
      title ||= l if m

      ls = extract_links(l)
    end
  end

  protected

  def trim(lines)

    lines
  end
end; end

