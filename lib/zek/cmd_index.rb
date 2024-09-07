
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

  def cmd_index(args, lines)

    index_each_file

    index_all_files

    #index_selves
    #index_links
      #
    #index_parents
    #index_trees
  end

  protected # beware, it's Zek/self here...

  def index_each_file

    Dir[Zek.path('*/*/*.md')].each do |path|

      ipath = path[0..-4] + '.i.yaml'

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
    pat = pat + '.i' unless pat.end_with?('.i')
    paty = pat + '.yaml'
    patr = pat + '.rb'

    d = File.exist?(patr) && (Marshal.load(File.read(patr)) rescue nil)
    d = d || (File.exist?(paty) && YAML.load_file(paty) rescue nil)

    d
  end

  def index_all_files

    #
    # make a first pass to index "selves", aka "self" links, aliases to oneself

    selves = {}

    Dir[Zek.path('*/*/*.md')].each do |path|

      u = Zek.extract_uuid(path)
      d = load_index(path)

      d[:links].each do |rel, href|

        next unless rel == 'self'

        if ! is_uuid?(href)
          (selves[u] ||= []) << href
          (selves[href] ||= []) << u
        end
      end
    end

    write_index(:selves, selves)

    reself = lambda { |href|
      u = extract_uuid(href)
      u ? href : (selves[u] || []).first }

    #
    # do the main indexing

    titles = {}
    words = {}
    tags = {}
    links = {}
    parents = {}
    children = {}

    Dir[Zek.path('*/*/*.md')].each do |path|

      u = Zek.extract_uuid(path)
      d = load_index(path)

      unless d
        puts "x  could not load index for #{path}, skipping..."
        next
      end

      (titles[d[:title].downcase] ||= []) << u

      d[:words].each { |w| (words[w] ||= []) << u }
      d[:tags].each { |w| (tags[w] ||= []) << u }

      d[:links].each do |rel, href|
        if rel == 'self'
          # already done above
        elsif rel == 'parent'
          #parents[u] = href
          pu = reself[href]
          parents[u] = pu
          (children[pu] ||= []) << u
        else
          hu = reself[href]
          a = [ u, rel, hu ]; a << href if href != hu
          (links[rel] ||= []) << a
          (links[href] ||= []) << a
        end
      end
    end

    titles = titles.sort.to_h
    words = words.sort.to_h
    tags = tags.sort.to_h
    links = links.sort.to_h
    selves = selves.sort.to_h
    parents = parents.sort.to_h
pp children
    children = children.sort.to_h

    write_index(:titles, titles)
    write_index(:words, words)
    write_index(:tags, tags)
    write_index(:links, links)
    write_index(:parents, parents)
    write_index(:children, children)

    trees = {}
# TODO

    write_index(:trees, trees)
  end

  def write_index(key, values)

    File.open(path("index/#{key}.yaml"), 'wb') { |f|
      f.write(YAML.dump(values)) }
    File.open(path("index/#{key}.rb"), 'wb') { |f|
      f.write(Marshal.dump(values)) }
  end
end; end

