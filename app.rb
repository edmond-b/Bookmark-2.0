require 'sinatra/base'
require './lib/bookmark'
require './lib/database_connection_setup'
require 'uri'
require 'sinatra/flash'
require './lib/comment'
require './lib/tag'
require './lib/bookmark_tag'
require './lib/user'

class BookmarkManager < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  get '/bookmarks' do
    @user = User.find(session[:user_id])
    @bookmarks = Bookmark.all
    erb(:index)
  end

  get '/bookmark/new' do
    erb(:new_bookmark)
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
    erb(:edit_bookmark)
  end

  patch '/bookmarks/:id' do
    Bookmark.update(id: params['id'], title: params[:title], url: params[:url])
    redirect('/bookmarks')
  end

  get '/bookmarks/:id/comments/new' do
    @bookmark_id = params[:id]
    erb(:new_comment)
  end

  post '/bookmarks/:id/comments' do
    Comment.create(text: params[:comment], bookmark_id: params[:id])
    redirect('/bookmarks')
  end

  get '/bookmarks/:id/tag/new' do
    @bookmark_id = params[:id]
    erb(:new_tag)
  end

  post '/bookmarks/:id/tag' do
    tag = Tag.create(content: params[:tag])
    BookmarkTag.create(bookmark_id: params[:id], tag_id: tag.id)
    redirect('/bookmarks')
  end

  get '/tags/:id/bookmarks' do
    @tag = Tag.find(id: params['id'])
    erb(:tags)
  end

  get '/users/new' do
    erb(:new_user)
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect('/bookmarks')
  end

  get '/session/new' do
    erb(:new_session)
  end

  post '/session' do
    user = User.authenticate(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect('/bookmarks')
    else
      flash[:notice] = 'Please check your email or password.'
      redirect('/session/new')
    end
  end

  post '/session/destroy' do
    session.clear
    flash[:notice] = 'You have signed out.'
    redirect('/bookmarks')
  end

  run! if app_file == $0
end
