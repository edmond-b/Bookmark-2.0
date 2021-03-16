require 'sinatra/base'
require './lib/bookmark'

class BookmarkManager < Sinatra::Base
  enable :sessions, :method_override

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb(:index)
  end

  get '/bookmark/new' do
    erb(:new)
  end

  post '/bookmarks' do
    Bookmark.create(url: params[:url], title: params[:title])
    redirect('/bookmarks')
  end

  delete '/bookmarks/:id' do
    Bookmark.delete(id: params['id'])
    redirect('/bookmarks')
  end

  run! if app_file ==$0
end
