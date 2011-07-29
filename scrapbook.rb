require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'haml'

require 'redcarpet'
require 'coderay'
require 'nokogiri'


OWNER_NAME = "eq8" 
@@render_files_patern = "/#{OWNER_NAME}s_:what/on_:name"
@@markup_path = "public/w/"




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
    path_to_file = @@render_files_patern.gsub(':what', what.to_s).gsub(':name', file_name.to_s)
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
        :home => "Home",
        :links => "Links"

      }
    }
  end
end



get '/' do
  public_path = "public/w/"

 # File.dirname(__FILE__)
 @articles = Dir.entries("#{@@markup_path}articles/" ) - ['.', '..']
 @notes = Dir.entries("#{@@markup_path}notes/" ) - ['.', '..']
 @scraps = Dir.entries("#{@@markup_path}scraps/" ) - ['.', '..']
 

  haml :index 
end



get @@render_files_patern do
  
  @title= "#{OWNER_NAME} #{params[:what]} on #{convert_to_link_name(params[:name])} "
  @h1_name = convert_to_link_name(params[:name]).capitalize
  @h1_what = params[:what]
  @file_path = "public/w/#{params[:what]}s/#{params[:name]}"

  begin
      file = File.open(@file_path, "r")
      @file_content=file.read
      file.close  
      haml params['what'].to_sym
 # rescue Errno::ENOENT
  #    haml :not_found
  end

end


