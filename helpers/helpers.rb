helpers do
  # I know, lot of stuff should be moved to libraries and shouldn't be
  # helper at all, I'll refactor that as soon as possible
  #
  def link_to(url, text=url, opts={}) 
    attributes = ""
    opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end

  def convert_to_link_name(file_name)
    file_name.gsub("_", ' ')
  end

  def convert_to_link_path_name(file_name)
    file_name
  end

  def link_to_file(what, file_name)
    path_to_file = settings.reder_w_files_patern.gsub(':what', what.to_s).gsub(':name', file_name.to_s)
    link_to path_to_file, convert_to_link_name(file_name)
  end

  def coderay(text,lang='ruby')
    CodeRay.scan(text,lang).div(:css => :class)
  end


def markdown(text)
 # options = [:filter_html, :hard_wrap, :autolink, :no_intraemphasis]
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(
      :hard_wrap => true
    ),
    :no_intra_emphasis => true, 
    :tables => false,
    :fenced_code_blocks => true, 
    :autolink => true, 
    :strikethrough => false,
    :lax_html_blocks => false,
    :space_after_headers => false,
    :superscript => false,
    :filter_html => true, 
    :gh_blockcode => true,
    :hard_wrap => true, 
  )
  syntax_highlighter(markdown.render(text))
end

def syntax_highlighter(html)
  doc = Nokogiri::HTML.parse(html)
  doc.search("//code").each do |pre|
    pre.replace coderay(pre.text.rstrip, pre[:class])
  end
  doc.css('body').inner_html.to_s
end


  def read_file(full_path_file_name)
    file = File.open( full_path_file_name, "r")
    file_content = file.read
    file.close

    file_content

  end

  def read_w_file(file_name)
    read_file(w_path(file_name))
  end

  def dir_w_listing(folder_name)
    (Dir.entries( w_path(folder_name )) - ['.', '..']).sort
  end

end
