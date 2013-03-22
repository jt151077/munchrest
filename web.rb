require 'sinatra'
require 'mongoid'
require 'digest'
require 'fileutils'

configure do
  Mongoid.configure do |config|
    if ENV['MONGOLAB_URI']
      uri = URI.parse(ENV['MONGOHQ_URL'])
      conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
      config.master = conn.db(uri.path.gsub(/^\//, ''))
    else
      name = "my_local_development_database"
      host = "localhost"
      config.master = Mongo::Connection.new.db(name)
    end
  end
end

get '/' do
  send_file File.join('public', 'index.html');
end