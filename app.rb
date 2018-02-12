require 'sinatra'

def get_dropbox_client
  if session[:access_token]
    return DropboxClient.new(session[:access_token])
  end
end

get '/' do
  
end
