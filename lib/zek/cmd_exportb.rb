
#
# zek/cmd_exportb.rb

module Zek::CmdExportb; class << self

  def execute(args, lines)

    selves = Zek.load_selves
    pu = selves['links']

    fail("Could not find parent [self](links)") unless pu

    pi = Zek.load_index(pu)
    cn = Zek.load_index('children')

    links = cn[pu]
      .collect { |cu| parse_note(cu) }
      .sort_by { |title, _| title }
pp links

    fn = "zek_bookmarks.html"
    path = File.join(Dir.home, 'Downloads', fn)

    File.open(path, 'wb') do |f|

      f.write(%{
        <html>
          <head>
            <title>#{Zek.repo_path} Bookmarks</title>
            <style>#{File.read(File.join(__dir__, 'cmd_exportb.css'))}</style>
          </head>
          <body>
      }.htrip)

      links.each do |c, ls|
        f.write("<h2>#{c}</h2>\n")
        f.write("<ul>\n")
        ls.each do |l|
          f.write("<li>")
          f.write("<a href=\"#{l[:href]}\">")
          f.write(l[:href])
          f.write("</a>")
          f.write("</li>\n")
        end
        f.write("</ul>\n")
      end

      f.write("</body></html>")
    end

    puts path
  end

  protected

  def parse_note(u)

    title = nil
    links = []

    File.readlines(Zek.note_path(u)).each do |l|

      if m = title.nil? && l.match(/^\#{1,2} (.+)$/)
        title = m[1]
      elsif m = l.match(/^\* (.+)$/)
        links << parse_link(m[1])
      end
    end

    [ title, links ]
  end

  def parse_link(s)

    { href: s }
  end
end; end

