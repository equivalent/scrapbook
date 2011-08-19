


helpers do
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
  options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
 # options = [:filter_html, :hard_wrap, :autolink, :no_intraemphasis]
  syntax_highlighter(Redcarpet.new(text, *options).to_html)
end

def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre[@lang]").each do |pre|
    pre.replace coderay(pre.text.rstrip, pre[:lang])
  end
  doc.to_s
end

  def read_file(full_path_file_name)
    file = File.open( full_path_file_name, "r")
    file_content = file.read
    file.close

    file_content

  end

  def read_w_file(file_name)
    read_file( w_path(file_name))
  end

  def dir_w_listing(folder_name)
      Dir.entries( w_path(folder_name )) - ['.', '..']
  end

end
