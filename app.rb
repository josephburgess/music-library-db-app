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

  get '/' do
    erb(:index)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    erb(:albums)
  end

  post '/albums' do
    if invalid_album_parameters?
      status 400
      return 'Please include both title and release year.'
    end
    @album = Album.new
    @album.title = params[:title]
    @album.release_year = params[:release_year]
    @album.artist_id = params[:artist_id]
    AlbumRepository.new.create(@album)
    erb(:album_created)
  end

  def invalid_album_parameters?
    params[:title].nil? || params[:release_year].nil?
  end

  def invalid_artist_parameters?
    params[:name].nil? || params[:genre].nil?
  end

  get '/albums/new' do
    erb(:new_album)
  end

  get '/artists/new' do
    erb(:new_artist)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    erb(:artists)
  end

  post '/artists' do
    if invalid_artist_parameters?
      status 400
      return 'Please include both artist and genre.'
    end
    @artist = Artist.new
    @artist.name = params[:name]
    @artist.genre = params[:genre]
    ArtistRepository.new.create(@artist)
    erb(:artist_created)
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
    albumrepo = AlbumRepository.new
    @artist = artistrepo.find(params[:id])
    @albums = []
    albumrepo.all.each do |album|
      @albums << album if album.artist_id == @artist.id
    end
    erb(:artist)
  end
end
