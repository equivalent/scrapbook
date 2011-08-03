require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'haml'

require 'redcarpet'
require 'coderay'
require 'nokogiri'

require "#{File.dirname(__FILE__)}/helpers/helpers.rb"


set :owner_name => "eq8"
set :reder_w_files_patern => "/#{settings.owner_name}s_:what/on_:name" #if you are changing this line, be sure you change the patern in w_path helper
set :w_files_path => "public/w/"

helpers do
  def w_path(file_string=nil) 
    file_string.nil? ? "#{settings.w_files_path}#{params[:what]}s/#{params[:name]}" : "#{settings.w_files_path}#{file_string}"
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


