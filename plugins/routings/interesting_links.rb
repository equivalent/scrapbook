get '/interesting_links' do
      @title = "Other interesting links (non-tech)"
      @file_content = read_w_file('other/readed_articles') 
      haml :markdown_read
end
