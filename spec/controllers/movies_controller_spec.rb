require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      fake_results = [double('movie1'), double('movie2')]
      allow(Movie).to receive(:find_in_tmdb).with('Ted').and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
  end
  describe 'searching TMDb with no value' do
    it 'should redirect to index page and show msg "Invalid search term"' do
      post :search_tmdb, {:search_terms => ''}
      expect(response).to redirect_to '/movies'
      expect(flash[:notice]).to eq 'Invalid search term'
    end
  end
  describe 'searching TMDb with any value except film name' do
    it 'should redirect to index page and show msg "No matching movies were found on TMDb"' do
      fake_results = []
      allow(Movie).to receive(:find_in_tmdb).with('sxcvbhjklmnbhgf').and_return(fake_results)
      post :search_tmdb, {:search_terms => 'sxcvbhjklmnbhgf'}
      expect(response).to redirect_to '/movies'
      expect(flash[:notice]). to eq 'No matching movies were found on TMDb'
   end
  end
  describe 'add TMDb' do
    context 'if no check box is selected' do
      it 'should return index page along with the msg "No movies selected"' do
        post :add_tmdb, {}
        expect(response).to redirect_to '/movies'
        expect(flash[:notice]).to eq 'No movies selected'
      end
    end
    context 'if check box is selected' do
      it 'should return index page with the msg "Movies successfully added to Rotten Potatoes"' do
        fake_results = [double('Movie'), double('Movie')]
        allow(Movie).to receive(:create_from_tmdb).with('27205').and_return(fake_results)
        post :add_tmdb, {:tmdb_movies => {"27205" => "1"}}
        expect(response).to redirect_to '/movies'
        expect(flash[:notice]).to eq 'Movies successfully added to Rotten Potatoes'
      end
    end
  end
end
