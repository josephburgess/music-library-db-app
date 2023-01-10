# file: app.rb
require 'sinatra'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    erb(:albums)
  end

  post '/albums' do
    repo = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo.create(album)
  end

  get '/albums/new' do
    erb(:new_album)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    erb(:artists)
  end

  post '/artists' do
    repo = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    repo.create(artist)
  end

  get '/albums/:id' do
    albumrepo = AlbumRepository.new
    artistrepo = ArtistRepository.new
    @album = albumrepo.find(params[:id])
    @artist = artistrepo.find(@album.artist_id)
    erb(:album)
  end

  get '/artists/:id' do
    artistrepo = ArtistRepository.new
    @artist = artistrepo.find(params[:id])
    erb(:artist)
  end
end
