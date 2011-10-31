get '/archive_of_developer_articles' do
      @title = "Archive of articles I had read"
      @file_content = read_w_file('other/readed_articles') 
      haml :markdown_read
end

get '/archive_of_designer_articles' do
      @title = "Archive of articles I had read"
      @file_content = read_w_file('other/readed_articles_html') 
      haml :markdown_read
end
