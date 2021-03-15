require 'sinatra/base'
require './lib/bookmark'

class Bookmark < Sinatra::Base
  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb(:index)
  end

  run! if app_file ==$0
end
