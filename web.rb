require 'sinatra'
require 'mongoid'
require 'digest'
require 'fileutils'
require 'uri'
require 'json'


Dir['./models/*.rb'].each {|file| require file }
configure do
  Mongoid.configure do |config|
    if ENV['MONGOLAB_URI']
      uri = URI.parse(ENV['MONGOLAB_URI'])
      conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
      config.master = conn.db(uri.path.gsub(/^\//, ''))
    else
      name = "munchobserver_app"
      host = "localhost"
      config.master = Mongo::Connection.new.db(name)
    end
  end
end

get '/' do
  send_file File.join('public', 'index.html');
end

# post a note
post '/notes' do
  request.body.rewind  # in case someone already read it
  content_type :json;
  data = JSON.parse request.body.read;

  note = Note.create(:content => data['content']);
  return note.to_json;
end

get '/notes' do
  @notes = Note.all();
  return @notes.to_json;
end
