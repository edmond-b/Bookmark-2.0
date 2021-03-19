require 'sinatra/base'
require './lib/bookmark'
require './lib/database_connection_setup'
require 'uri'
require 'sinatra/flash'
require './lib/comment'
require './lib/tag'
require './lib/bookmark_tag'

class BookmarkManager < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb(:index)
  end

  get '/bookmark/new' do
    erb(:new)
  end

  post '/bookmarks' do
    flash[:notice] = "You must submit a valid URL." unless Bookmark.create(url: params[:url], title: params[:title])
    redirect('/bookmarks')
  end

  delete '/bookmarks/:id' do
    Bookmark.delete(id: params['id'])
    redirect('/bookmarks')
  end

  get '/bookmarks/:id/edit' do
    @bookmark = Bookmark.find(id: params[:id])
    erb(:edit)
  end

  patch '/bookmarks/:id' do
    Bookmark.update(id: params['id'], title: params[:title], url: params[:url])
    redirect('/bookmarks')
  end

  get '/bookmarks/:id/comments/new' do
    @bookmark_id = params[:id]
    erb(:comment)
  end

  post '/bookmarks/:id/comments' do
    Comment.create(text: params[:comment], bookmark_id: params[:id])
    redirect('/bookmarks')
  end

  get '/bookmarks/:id/tag/new' do
    @bookmark_id = params[:id]
    erb(:tag)
  end

  post '/bookmarks/:id/tag' do
    tag = Tag.create(content: params[:tag])
    BookmarkTag.create(bookmark_id: params[:id], tag_id: tag.id)
    redirect('/bookmarks')
  end

  run! if app_file ==$0
end
