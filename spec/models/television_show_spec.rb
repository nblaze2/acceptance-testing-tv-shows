require "spec_helper"

describe TelevisionShow do
  let(:tvshow) {TelevisionShow.new('Archer', 'FX', '2009', 'Comedy', 'Raunchy animated spoof of spy agency')}
  let(:badtvshow) {TelevisionShow.new('Archer', 'FX', '2009', '', 'Raunchy animated spoof of spy agency')}

  it "takes title, network, starting_year, genre, and synopsis as arguments" do
      expect(tvshow).to be_a(TelevisionShow)
  end

  describe "#title" do
    it "has a reader for title" do
      expect(tvshow.title).to eq("Archer")
    end

    it "does not have a writer for title" do
      expect { tvshow.title = "Brussels Sprouts" }.to raise_error(NoMethodError)
    end
  end

  describe "#self.all" do
    it "returns an array of all the player objects" do
      CSV.open("television-shows.csv", "w", headers: true) do |csv|
        csv << ['Archer', 'FX', '2009', 'Comedy', 'Raunchy animated spoof of spy agency']
        csv << ['West Wing', 'NBC', '1999', 'Drama', 'Follow the trials and triumpfs of the people who work in the West Wing']
        csv << ['Seinfeld', 'NBC', '1989', 'Comedy', 'It is a show about nothing. No really.']
      end
      expect(TelevisionShow.all).to be_a(Array)
      expect(TelevisionShow.all.first).to be_a(TelevisionShow)
    end
  end

  describe "#valid?" do
    context "has all fields filled in and the title doesn't match any already in csv" do
      it "returns true if" do
        expect(tvshow.valid?).to eq(true)
        expect(tvshow.errors.empty?).to eq(true)
      end
    end

    context "has a missing field" do
      it "returns 'Please fill in all required fields' when" do
        expect(badtvshow.valid?).to eq(false)
        expect(badtvshow.errors.empty?).to eq(false)
        expect(badtvshow.errors).to be_a(Array)
        expect(badtvshow.errors.include?('Please fill in all required fields')).to eq(true)
      end
    end

    context "tried to check a show that already exists in the csv" do
      let(:tvshow) {TelevisionShow.new('Archer', 'FX', '2009', 'Comedy', 'Raunchy animated spoof of spy agency')}
      it "returns 'The show has already been added' when" do
        CSV.open("television-shows.csv", "wb", headers: true) do |csv|
          csv << ['Archer', 'FX', '2009', 'Comedy', 'Raunchy animated spoof of spy agency']
        end
        expect(tvshow.valid?).to eq(false)
        expect(tvshow.errors.empty?).to eq(false)
        expect(tvshow.errors).to be_a(Array)
        expect(tvshow.errors.include?('The show has already been added')).to eq(true)
      end
    end
  end

  describe "#save" do
    it "returns true and saves to the csv file if the object is valid" do
      expect(tvshow.save).to eq(true)
      title = ""
      CSV.foreach("television-shows.csv", headers: true) do |row|
        title += row[0]
        break
      end
      expect(title).to eq(tvshow.title)
    end

    it "returns false and does not save to the csv file if the object is not valid" do
      expect(badtvshow.save).to eq(false)
    end
  end
end
