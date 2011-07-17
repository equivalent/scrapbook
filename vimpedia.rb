require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'haml'


helpers do
  def link_to(url, text=url, opts={}) 
    attributes = ""
    opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
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


