get '/readed-backlog' do
  @readed_articles = read_w_file('other/readed_articles')
  haml :readed_articles
end

