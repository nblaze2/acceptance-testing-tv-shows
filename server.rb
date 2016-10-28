require 'sinatra'
require 'csv'
require_relative "app/models/television_show"

set :bind, '0.0.0.0'  # bind to all interfaces
set :views, File.join(File.dirname(__FILE__), "app/views")

get '/television_shows' do
  @tv_shows = CSV.readlines('television-shows.csv')
  erb :index
end

get '/television_shows/new' do
  erb :new
end

post '/television_shows' do
  @error = {}
  @title = params['title']
  if @title.empty?
    @error[:title] = "You must include a Title"
  end

  CSV.foreach("television-shows.csv") do |row|
    if @url == row[0]
      @error[:title] = "That article has already been submitted. Please submit another."
      break
    end
  end

  @network = params['network']
  if @network.empty?
    @error[:network] = "You must include a Network"
  end

  @starting_year = params['starting_year']
  if @starting_year.empty?
    @error[:starting_year] = "You must include a Starting Year"
  end


  @synopsis = params['synopsis']
  if @synopsis.empty?
    @error[:synopsis] = "You must include a Synopsis"
  elsif @synopsis.length < 20
    @error[:synopsis] = "You must include a Synopsis of at least 20 characters"
  end

  @genre = params['genre']
  if @genre.empty?
    @error[:genre] = "You must include a Genre"
  end

  if @error.keys.empty?
    CSV.open('television-shows.csv', 'a') do |csv|
      csv << [@title, @network, @starting_year, @synopsis, @genre]
    end
    redirect '/television_shows'
  else
    erb :new
  end
end
