get '/interesting_links' do
      @title = "Other readed stuff"
      @file_content = read_w_file('other/readed_articles_other') 
      haml :markdown_read
end
