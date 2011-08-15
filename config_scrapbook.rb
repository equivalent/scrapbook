set :owner_name => "eq8"
set :reder_w_files_patern => "/#{settings.owner_name}s_:what/on_:name" #if you are changing this line, be sure you change the patern in helper/w_path.rb helper
set :w_files_path => "public/w/"

#if you want restrict access
#use Rack::Auth::Basic, "Restricted Area" do |username, password|
#  [username, password] == ['admin', 'admin']
#end


