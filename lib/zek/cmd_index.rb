
#
# zek/cmd_index.rb


module Zek::CmdIndex; class << self

  def execute(args, lines)

    ensure_stop_words

    index_each_file
    index_all_files
  end

  protected

  def to_kmgt(i)

    ' KMGTP'.each_char do |k|
      return "#{i}#{k}".strip if i < 1024
      i = i / 1024
    end

    -1
  end

  def ensure_stop_words

    FileUtils.mkdir_p(Zek.path('index'))

    swpath = Zek.path('index/_stop_words.txt')

    FileUtils.cp(File.join(__dir__, '_stop_words.txt'), swpath) \
      unless File.exist?(swpath)
  end

  def index_each_file

    Dir[Zek.path('*/*/*.md')].each do |path|

      ipath = path[0..-4] + '.i.yaml'

      fmtime = File.mtime(path)
      imtime = File.mtime(ipath) rescue Time.at(0)

      index_file(path, ipath) if fmtime > imtime
    end
  end

  def index_file(path, ipath)

    d = Zek.do_index_lines(File.readlines(path))
      # which is found in lib/zek/cmd_make.rb ...

    File.open(ipath, 'wb') { |f| f.write(YAML.dump(d)) }

    rpath = ipath[0..-6] + '.rb'
    File.open(rpath, 'wb') { |f| f.write(Marshal.dump(d)) }

    nil
  end

  def index_all_files

    #
    # make a first pass to index "selves", aka "self" links, aliases to oneself

    selves = sort_index_hash(

      Dir[Zek.path('*/*/*.md')].inject({}) { |h, path|

        u = Zek.extract_uuid(path)
        d = Zek.load_index(u)

        d[:links].each do |rel, href|

          next unless rel == 'self'

          unless Zek.is_uuid?(href)
            (h[u] ||= []) << href
            (h[href] ||= []) << u
          end
        end
        h })
#puts "selves:"; pp selves

    write_index(:selves, selves)

    reself = lambda { |href|
      u = Zek.extract_uuid(href)
      u ? href : (selves[href] || []).first }

    #
    # do the main indexing

    uuids = []
    titles = {}
    words = {}
    tags = {}
    links = {}
    parents = {}
    children = {}

    Dir[Zek.path('*/*/*.md')].each do |path|

      u = Zek.extract_uuid(path)

      uuids << u

      d = Zek.load_index(u)

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
#puts "links:"; pp links
    parents = sort_index_hash(parents)
#puts "parents:"; pp parents
    children = sort_index_hash(children)
#puts "children:"; pp children

    write_index(:titles, titles)
    write_index(:words, words)
    write_index(:tags, tags)
    write_index(:links, links)
    write_index(:parents, parents)
    write_index(:children, children)

    #
    # trees

    nodes = uuids
      .sort
      .inject({}) { |h, u| h[u] = [ u, [] ]; h }
        #
    children.each { |u, cn|
      n = nodes[u]
      cn.each { |cu| n[1] << nodes[cu] } }
#puts; puts "nodes:"; pp nodes

    pks = parents.keys
    trees = nodes.values.reject { |u, cn| pks.include?(u) }
#puts "trees:"; trees.each { |t| pp t }

    deself = lambda { |n|
      u0, cn = n
      u1 = selves[u0]; u1 = u1 ? u1.first : nil
      [ u0, u1, cn.collect { |c| deself[c] } ] }

    trees1 = trees
      .collect { |n| deself[n] }
#puts "trees1:"; trees1.each { |t| pp t }

    #write_index(:trees, trees)
    write_index(:trees, trees1)

    #
    # nets

    edges = links.values
      .flatten(1)
      .collect { |src, rel, dst, _| Zek.uuid?(dst) ? [ src, rel, dst ] : nil }
      .compact
      .uniq

    m = lambda { |e0, e1| i = e0 & e1; !! i.find { |e| Zek.uuid?(e) } }

    nets = edges
      .inject([]) { |a, e|
        if trail = a.find { |t| t.find { |ee| m[ee, e] } }
          trail << e
        else
          a << [ e ]
        end
        a }
      .collect { |n|
        n.flatten(1).uniq.select { |e| Zek.uuid?(e) }.sort }
#puts "nets:"; nets.each { |t| pp t }

    write_index(:nets, nets)

    #
    # summaries

    compute_root_and_depth = lambda { |u|
      compute_ = lambda { |d, n|
        return d if n[0] == u
        n[1].each { |nn|
          dd = compute_[d + 1, nn]
          return dd if dd }
        nil }
      trees.each { |t|
        d = compute_[0, t]
        return [ t[0], d ] if d
        }
      nil }

    summaries = {}

    Dir[Zek.path('*/*/*.md')].each do |path|

      u = Zek.extract_uuid(path)
      d = Zek.load_index(u)

      ro, de = compute_root_and_depth[u]

      li = d[:links].count { |rel, href| ! %w[ parent self ].include?(rel) }

      n = nets .find { |n| n.include?(u) }
      n = n ? n.first : nil

      summaries[u] = {
        title: d[:title],
        line: d[:line],
        tags: d[:tags],
        lines: File.readlines(path).count,
        size: to_kmgt(File.size(path)),
        root: ro,
        depth: de || 0,
        parent: parents[u],
        children: children[u] || [],
        attcs: d[:attcs].size,
        links: li,
        net: n }
    end

    summaries = sort_index_hash(summaries)
#puts "summaries:"; pp summaries

    write_index(:summaries, summaries)
  end

  def combine_trails(edges)

  end

  def sort_index_hash(h)

    h.each { |k, v| h[k] = v.sort if v.is_a?(Array) }.sort.to_h
  end

  def write_index(key, values)

    File.open(Zek.path("index/#{key}.yaml"), 'wb') { |f|
      f.write(YAML.dump(values)) }

    File.open(Zek.path("index/#{key}.rb"), 'wb') { |f|
      f.write(Marshal.dump(values)) }
  end
end; end

