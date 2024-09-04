
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

    index_core # title, words, and tags
# TODO
    #index_selves
    #index_parents
    #index_links
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

    rpath = ipath[0..-6] + '.rb'
    File.open(rpath, 'wb') { |f| f.write(Marshal.dump(d)) }

    nil
  end

  def load_index(path)

    pat = path[0..path.rindex('.') - 1]
    pat = pat + '.index' unless pat.end_with?('.index')
    paty = pat + '.yaml'
    patr = pat + '.rb'

    d = File.exist?(patr) && (Marshal.load(File.read(patr)) rescue nil)
    d = d || (File.exist?(paty) && YAML.load_file(paty) rescue nil)

    d
  end

  def index_core

    titles = {}
    words = {}
    tags = {}

    Dir[Zek.path('*/*/n_*.md')].each do |path|

      u = Zek.extract_uuid(path)
      d = load_index(path)

      unless d
        puts "x  could not load index for #{path}, skipping..."
        next
      end

      (titles[d[:title].downcase] ||= []) << u

      d[:words].each { |w| (words[w] ||= []) << u }
      d[:tags].each { |w| (tags[w] ||= []) << u }
    end

    titles = titles.sort.to_h
    words = words.sort.to_h
    tags = tags.sort.to_h

    write_index(:titles, titles)
    write_index(:words, words)
    write_index(:tags, tags)
  end

  def write_index(key, values)

    File.open(path("index/#{key}.yaml"), 'wb') { |f|
      f.write(YAML.dump(values)) }
    File.open(path("index/#{key}.rb"), 'wb') { |f|
      f.write(Marshal.dump(values)) }
  end
end; end

