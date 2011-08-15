
helpers do
  def w_path(file_string=nil) 
    file_string.nil? ? "#{settings.w_files_path}#{params[:what]}s/#{params[:name]}" : "#{settings.w_files_path}#{file_string}"
  end
end
