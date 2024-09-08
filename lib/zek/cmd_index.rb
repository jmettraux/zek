
#
# zek/cmd_index.rb


module Zek; class << self

  def cmd_index(args, lines)

    ensure_stop_words

    index_each_file

    index_all_files

# FIXME
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

    selves = sort_index_hash(

      Dir[Zek.path('*/*/*.md')].inject({}) { |h, path|

        u = Zek.extract_uuid(path)
        d = load_index(path)

        d[:links].each do |rel, href|

          next unless rel == 'self'

          if ! is_uuid?(href)
            (h[u] ||= []) << href
            (h[href] ||= []) << u
          end
        end
        h })
puts "selves:"; pp selves

    write_index(:selves, selves)

    reself = lambda { |href|
      u = extract_uuid(href)
      u ? href : (selves[href] || []).first }

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
          pu = reself[href]
          parents[u] = pu
          (children[pu] ||= []) << u
        else
          hu = reself[href] || href
          a = [ u, rel, hu ]; a << href if href != hu
          (links[rel] ||= []) << a
          (links[href] ||= []) << a
        end
      end
    end

    titles = sort_index_hash(titles)
#puts "titles:"; pp titles
    words = sort_index_hash(words)
#puts "words:"; pp words
    tags = sort_index_hash(tags)
#puts "tags:"; pp tags
    links = sort_index_hash(links)
puts "links:"; pp links
    parents = sort_index_hash(parents)
puts "parents:"; pp parents
    children = sort_index_hash(children)
puts "children:"; pp children

#    write_index(:titles, titles)
#    write_index(:words, words)
#    write_index(:tags, tags)
#    write_index(:links, links)
#    write_index(:parents, parents)
#    write_index(:children, children)
#
#    trees = {}
## TODO
#
#    write_index(:trees, trees)
  end

  def sort_index_hash(h)

    h.each { |k, v| h[k] = v.sort if v.is_a?(Array) }.sort.to_h
  end

  def write_index(key, values)

    File.open(path("index/#{key}.yaml"), 'wb') { |f|
      f.write(YAML.dump(values)) }
    File.open(path("index/#{key}.rb"), 'wb') { |f|
      f.write(Marshal.dump(values)) }
  end

  def ensure_stop_words

    FileUtils.mkdir_p(Zek.path('index'))

    swpath = Zek.path('index/stop_words.txt')

    File.open(swpath, 'wb') { |f| f.write(%{
      a about above after again against all am an and any are aren't as at be
      because been before being below between both but by can't cannot could
      couldn't did didn't do does doesn't doing don't down during each few
      for from further had hadn't has hasn't have haven't having he he'd
      he'll he's her here here's hers herself him himself his how how's i i'd
      i'll i'm i've if in into is isn't it it's its itself let's me more most
      mustn't my myself no nor not of off on once only or other ought our
      ours ourselves out over own same shan't she she'd she'll she's should
      shouldn't so some such than that that's the their theirs them
      themselves then there there's these they they'd they'll they're they've
      this those through to too under until up very was wasn't we we'd we'll
      we're we've were weren't what what's when when's where where's which
      while who who's whom why why's with won't would wouldn't you you'd
      you'll you're you've your yours yourself yourselves })
    } unless File.exist?(swpath)
  end
end; end

