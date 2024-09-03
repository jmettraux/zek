
#
# zek/cmd_index.rb

# index/
#   mtimes.yaml # { path: mtime_when_indexed }
#   tags.yaml
#   trees.yaml
#   links.yaml # ? is it really necessary
#   aliases.yaml
#   words.yaml # OR
#   words/
#     ant.txt
#     myrmidon.txt
#     zebra.txt # OR
#   words/
#     a.yaml
#     b.yaml
#     z.yaml
#     nonlatin.yaml

module Zek; class << self

  def cmd_index(lines)

    index_each_file

    index_words
# TODO
    #index_tags
    #index_titles
    #index_selves
    #index_parents
  end

  protected # beware, it's Zek/self here...

  def index_each_file

    Dir[Zek.path('*/*/n_*.md')].each do |path|

      ipath = path[0..-4] + '.index.yaml'

      fmtime = File.mtime(path)
      imtime = File.mtime(ipath) rescue Time.at(0)

      index_file(path, ipath) if fmtime > imtime
    end
  end

  def index_file(path, ipath)

    d = do_index_lines(File.readlines(path))
      # which is found in lib/zek/cmd_make.rb ...

    File.open(ipath, 'wb') { |f| f.write(YAML.dump(d)) }

    nil
  end

  def index_words

    ws = {}

    Dir[Zek.path('*/*/n_*.index.yaml')].each do |path|

      u = Zek.extract_uuid(path)
      d = YAML.load_file(path) rescue nil

      unless d
        puts "x  could not load #{path}, skipping..."
        next
      end

      d[:words].each do |w|

        (ws[w] ||= []) << u
      end
    end

    File.open(path('index/words.yaml'), 'wb') { |f| f.write(YAML.dump(ws)) }
  end
end; end

