require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'haml'

require 'redcarpet'
require 'coderay'
require 'nokogiri'


set :owner_name => "eq8"
set :reder_w_files_patern => "/#{settings.owner_name}s_:what/on_:name" #if you are changing this line, be sure you change the patern in w_path helper
set :w_files_path => "public/w/"

helpers do

  def w_path(file_string=nil) 
    file_string.nil? ? "#{settings.w_files_path}#{params[:what]}s/#{params[:name]}" : "#{settings.w_files_path}#{file_string}"
  end

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


  def read_w_file(file_name)
    file = File.open( w_path(file_name) , "r")
    file_content = file.read
    file.close

    file_content
  end

  def dir_w_listing(folder_name)
      Dir.entries( w_path(folder_name )) - ['.', '..']
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

before do
  @sidelinks = read_w_file('links_side')

end

get '/' do
 @articles = dir_w_listing 'articles/'
 @notes = dir_w_listing 'notes/'
 @scraps = dir_w_listing 'scraps/'

  haml :index 
end



get settings.reder_w_files_patern do
  
  @title= "#{settings.owner_name} #{params[:what]} on #{convert_to_link_name(params[:name])} "
  @h1_name = convert_to_link_name(params[:name]).capitalize
  @h1_what = params[:what]



  begin
      @file_content = read_w_file(@file_path)
      haml params['what'].to_sym
 # rescue Errno::ENOENT
  #    haml :not_found
  end

end


