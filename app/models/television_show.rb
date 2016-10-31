class TelevisionShow
  GENRES = ["Action", "Mystery", "Drama", "Comedy", "Fantasy"]

  attr_reader :title, :network, :starting_year, :genre, :synopsis
  attr_accessor :errors

  def initialize(title, network, starting_year, genre, synopsis)
    @title = title
    @network = network
    @starting_year = starting_year
    @genre = genre
    @synopsis = synopsis
    @errors = []
  end

  def self.all
    @tv_show_objs = []
    CSV.foreach("television-shows.csv", headers: true) do |row|
      @tv_show_objs << TelevisionShow.new(row[0], row[1], row[2], row[3], row[4])
    end
    @tv_show_objs
  end

  def valid?
    valid = true
    if @title.length == 0 || @network.length == 0 || @starting_year.length == 0 || @genre.length == 0 || @synopsis.length == 0
      @errors << "Please fill in all required fields"
      valid = false
    end

    CSV.foreach("television-shows.csv") do |row|
      if row[0] == @title
        @errors << "The show has already been added"
        valid = false
      end
    end
    return valid
  end

  def save
    if valid?
      CSV.open('television-shows.csv', 'a') do |csv|
        csv << [@title, @network, @starting_year, @synopsis, @genre]
      end
      true
    else
      false
    end
  end
end
