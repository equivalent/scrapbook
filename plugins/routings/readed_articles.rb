get '/read-articles-backlog' do
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

