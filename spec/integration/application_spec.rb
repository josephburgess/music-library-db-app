require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET to /albums' do
    it 'returns a list of albums as HTML' do
      response = get('/albums')
      expect(response.status).to eq 200

      expect(response.body).to include 'Title: <a href = "/albums/2">Surfer Rosa</a>'
      expect(response.body).to include 'Released: 1988'
      expect(response.body).to include 'Title: <a href = "/albums/1">Doolittle</a>'
    end
  end

  context 'POST to /albums' do
    it 'adds new album to database' do
      response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: 2)
      expect(response.status).to eq 200
      response = get('/albums')
      expect(response.status).to eq 200
      expect(response.body).to include('Voyage')
    end
  end

  context 'GET to /artists' do
    it 'returns the artist list' do
      response = get('/artists')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'
      expect(response.status).to eq 200
      expect(response.body).to eq expected_response
    end
  end

  context 'POST to /artists' do
    it 'adds artists to the list' do
      response = post('/artists', name: 'Wild Nothing', genre: 'Indie')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Wild Nothing'
      expect(response.status).to eq 200
      response = get('/artists')
      expect(response.status).to eq 200
      expect(response.body).to eq expected_response
    end
  end

  context 'GET to /albums/:id' do
    it 'returns the appropriate album in HTML format' do
      response = get('/albums/1')
      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Doolittle</h1>'
      expect(response.body).to include 'Release year: 1989'
      expect(response.body).to include 'Artist: Pixies'
    end
  end

  context 'GET to /artists/:id' do
    it 'returns the details for the specified artist' do
      response = get('/artists/1')
      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Pixies</h1>'
      expect(response.body).to include 'Genre: Rock'
    end
  end
end
