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
    it 'returns a list of albums' do
      response = get('/albums')
      expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context 'POST to /albums' do
    it 'adds new album to database' do
      response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: 2)
      expect(response.status).to eq(200)
      expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring, Voyage'
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
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
      expect(response.status).to eq(200)
      expect(response.body).to eq expected_response
    end
  end
end
