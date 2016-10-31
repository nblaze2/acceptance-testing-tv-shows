require 'sinatra'
require 'csv'
require 'pry'
require_relative "app/models/television_show"

set :bind, '0.0.0.0'  # bind to all interfaces
set :views, File.join(File.dirname(__FILE__), "app/views")

get '/television_shows' do
  @tv_shows = TelevisionShow.all
  erb :index
end

get '/television_shows/new' do
  erb :new
end

post '/television_shows' do
  @title = params[:title]
  @network = params[:network]
  @starting_year = params[:starting_year]
  @genre = params[:genre]
  @synopsis = params[:synopsis]

  @television_show = TelevisionShow.new(@title, @network, @starting_year, @genre, @synopsis)

  if @television_show.valid?
    @television_show.save
    redirect '/television_shows'
  else
    erb :new
  end
end
