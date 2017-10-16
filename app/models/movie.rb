class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      a = Array.new
      #matching_movies = Array.new
      matching_movies = Tmdb::Movie.find(string)
      matching_movies.each do |movie|
        #a = movie.title
        #b = movie.id
        #c = movie.release_date
        #puts "Title = #{a}"
        #puts "Release Date = #{c}"
        #d = Tmdb::Movie.releases(movie.id)
        e = Tmdb::Movie.releases(movie.id)["countries"]
        #puts e
        new_hash = {:tmdb_id => movie.id, :title => movie.title, :release_date => movie.release_date}
        #new_hash[:tmdb_id] = movie.id
        #new_hash[:title] = movie.title
        #new_hash[:release_date] = movie.release_date
        e.each do |country_ratings|
          #f = country_ratings["certification"]
          # puts f
          # puts "*******************************************************"
          #puts "Rating = #{d}"
          #g = country_ratings["iso_3166_1"]
          if country_ratings["iso_3166_1"] == "US"
            new_hash[:rating] = country_ratings["certification"]
            break
          end
        end
        #puts new_hash
        a.push(new_hash)
      end
      #puts a
      return a
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end

  def Movie::create_from_tmdb(id)
    a = Tmdb::Movie.detail(id)
    b = Hash.new
    
    b = {:title =>  a["title"], :release_date => a["release_date"], :description => a["overview"]}
    e = Tmdb::Movie.releases(id)["countries"]
    e.each do |rating|
      if rating["iso_3166_1"] == "US"
        b[:rating] = rating["certification"]
        break
      end
    end
    puts b
    Movie.create(b)
  end
end
