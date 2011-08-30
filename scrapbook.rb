require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'haml'

require 'redcarpet'
require 'coderay'
require 'nokogiri'

require "#{File.dirname(__FILE__)}/config_scrapbook.rb"
require "#{File.dirname(__FILE__)}/helpers/w_path.rb"
require "#{File.dirname(__FILE__)}/helpers/helpers.rb"







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
  @plugin_right_sidebar_partials =  Dir[File.dirname(__FILE__) + '/plugins/right_side_partials/*.haml']
end

get '/' do
 @articles = dir_w_listing 'articles/'
 @notes = dir_w_listing 'notes/'
 @scraps = dir_w_listing 'scraps/'
 @plugin_index_partials = Dir[File.dirname(__FILE__) + '/plugins/index_partials/*.haml']

  haml :index 
end



get settings.reder_w_files_patern do
  @title= "#{settings.owner_name} #{params[:what]} on #{convert_to_link_name(params[:name])} "
  @h1_name = convert_to_link_name(params[:name]).capitalize
  @h1_what = params[:what]
  begin
      @file_content = read_w_file(nil) 
      haml params['what'].to_sym
  rescue Errno::ENOENT
      haml :not_found
  end
end

get '/links' do
      @title = "links"
      @file_content = read_w_file('links') 
      haml :markdown_read
end

Dir[File.dirname(__FILE__) + '/plugins/routings/*.rb'].each {|file| require file } 
