require 'rubygems'
require 'sinatra'
require 'haml'

require 'redcarpet'
require 'coderay'
require 'nokogiri'

require "#{File.dirname(__FILE__)}/lib/content_for.rb"
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
        :scraps => "Notes & Articles",
        :read_articles => "Read backlog",
        :links => "Links"
      }
    }
  end
end

before do
  @sidelinks = read_w_file('links_side')
  @plugin_right_sidebar_partials =  Dir[File.dirname(__FILE__) + '/plugins/right_side_partials/*.haml']
end


get '/stylesheet.css' do
  # in sinatra what is in public goes before routes.. so compiled stylesheet is public directory will go before uncompiled sass one
  # compile in bash:   sass views/stylesheet.sass public/stylesheet.css
  sass :stylesheet, :style => :expanded
end

get '/' do
  @articles = dir_w_listing 'articles/'
  @notes = dir_w_listing 'notes/'
  @scraps = dir_w_listing 'scraps/'
  @plugin_index_partials = Dir[File.dirname(__FILE__) + '/plugins/homepage_partials/*.haml']
  @html_id="home"

  haml :homepage
end



get settings.reder_w_files_patern do
  @title= "#{settings.owner_name}'s #{params[:what]} on #{convert_to_link_name(params[:name])} "
  @h1_name = convert_to_link_name(params[:name]).capitalize
  @h1_what = params[:what]
  begin
      @file_content = read_w_file(nil) 
      haml params['what'].to_sym
  rescue Errno::ENOENT
     redirect '/'
  end
end

get '/links' do
  @title = "links"
  @file_content = read_w_file('links') 
  haml :markdown_read
end

get '/read-articles-backlog' do
  # todo refactor this
  @railscasts = { 
    283 => '',
    279 => 'Asset pipeline', 
    255 => '', 
    241 => 'Omniauth form scratch', 
    238 => '', 
    235 => 'Implementing omniauth to existing project', 
    233 => 'janrain rpx authentication with other provider', 
    209 => 'devise authentication', 
    205 => '',
    194 => '', 
    126 => '',
    81  => '', 
    11  => ''
  }
  @readed_articles = read_w_file('other/readed_articles')
  @html_id='read_backlog'
  haml :readed_articles
end


Dir[File.dirname(__FILE__) + '/plugins/routings/*.rb'].each {|file| require file } 
