require 'sinatra'
require 'dropbox'
require 'dotenv/load'

def get_dropbox_client
  Dropbox::Client.new(ENV['DROPBOX_API_TOKEN'])
end

get '/' do
  client = get_dropbox_client
  path = '/Camera Uploads'

  out = []
  resp = client.send(:request, '/files/list_folder', path: path)

  loop do
    resp['entries'].each do |entry|
      out << entry['path_display']
    end

    break unless resp['has_more']

    resp = client.send(:request, '/files/list_folder/continue', cursor: resp['cursor'])
  end

  path = out.sample
  metadata, image = client.download(path)

  content_type 'image/jpeg'

  image
end
