require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'haml'

require 'redcarpet'
require 'albino'
require 'nokogiri'


OWNER_NAME = "eq8" 
@@render_files_patern = "/#{OWNER_NAME}s_:what/on_:name"




helpers do
  def link_to(url, text=url, opts={}) 
    attributes = ""
    opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end

  def coderay(text,lang='ruby')
    text=text.gsub(/!@#.*$/,'')
    content_tag("notextile", CodeRay.scan(text,lang).div(:css => :class).html_safe)
  end

  def coderay_article(text)
    text.gsub(/\!ccc(.+?)ccc/m) do
      coderay($1)
    end
  end

def markdown(text)
  options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
  syntax_highlighter(Redcarpet.new(text, *options).to_html)
end

def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  doc.to_s
end



end

#ultra simple & dum I18n
class I
  def self.t(key)
    key.to_s.split('.').map(&:to_sym).inject(self.translation, :[])
  end
protected
  def self.translation
    {
      :links => {
        :quick_notes => "Quick Notes",
        :scraps => "Scraps",
        :articles => "Articles",
        :links => "Links"

      }
    }
  end
end



get '/' do
  haml :index 
end



get @@render_files_patern do
  
  @title= ""
  @h1_name = params[:name].capitalize
  @file_path = "public/w/#{params[:what]}/#{params[:name]}"

  begin
      file = File.open(@file_path, "r")
      @file_content=file.read
      file.close  
      haml :note
  rescue Errno::ENOENT
      haml :index
  end

end


