get '/archive_of_articles' do
      @title = "Archive of articles/posts I have red"
      @file_content = read_w_file('other/readed_articles') 
      haml :markdown_read
end
