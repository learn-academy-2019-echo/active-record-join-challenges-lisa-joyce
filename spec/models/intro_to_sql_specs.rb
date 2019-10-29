require 'rails_helper'

RSpec.describe "Practice with ActiveRecord", type: :model do
  describe "Where" do
    it "can find records and attributes (class)" do
      #What is the population of the US?
      us = Country.where(code: 'USA').first
      expect(us.population).to eq(278357000)
    end

    it "can find records and attributes" do
      #What is the area of the US?
      us = Country.where(code: 'USA').first
      expect(us.surfacearea).to eq(9363520.0)
    end

    it "can find records and attributes" do
      #What is the population of Canada?
      canada = Country.where(code: 'CAN').first
      expect(canada.population).to eq(31147000)
    end

    it "can find records and attributes" do
      #What is the area of Canada?
      canada = Country.where(code: 'CAN').first
      expect(canada.surfacearea).to eq(9970610.0)
    end


    it "can find records via equality comparrison (class)" do
      #List the number of countries in Europe that have a surface area greater than 200,000 km squared.
      area = 200_000
      countries = Country
        .where("surfacearea > ?", area)
        .where(continent: 'Europe')
      expect(countries.count).to eq(13)
    end

    it "can find records via equality comparrison" do
      #List the countries in Europe that have a life expectancy of more than 78?
      countries = Country
        .where(continent: 'Europe')
        .where("lifeexpectancy > 78")
      expect(countries.count).to eq(15)
    end

    it "can find records via equality comparrison" do
      #List the countries in Europe that have a life expectancy of less than 77?
      countries = Country
        .where("continent = 'Europe' AND lifeexpectancy <77")
      expect(countries.count).to eq(22)
    end

    it "can combine comaparisons" do
      #List the countries in Europe that have a life expectancy of less than 77 and surfacearea less than 50,000 km.?
      area = 50_000
      countries = Country
        .where("continent = 'Europe' AND lifeexpectancy < 77 AND surfacearea < ?", area)
      expect(countries.count).to eq(7)
    end

    it "can find records via equality comparrison" do
      #List the countries that have a population greater than 30,000,000 and a life expectancy of more than 45?
      population = 30_000_000
      countries = Country
        .where("population > ? AND lifeexpectancy > 45", population)
      expect(countries.count).to eq(35)
    end

    it "can find records via multiple equality comparrisons" do
      #List the countries in Africa that have a population smaller than 30,000,000 and a life expectancy of more than 45?
      population = 30_000_000
      countries = Country
        .where("population > ? AND lifeexpectancy > 45 AND continent = 'Africa'", population)
      expect(countries.count).to eq(8)
   end

    it "can find records using wildcards" do
      #Which countries are something like a republic?
      #(are there 122 or 143 countries or ?)
      countries = Country
        .where("governmentform LIKE '%Republic%'")
      expect(countries.count).to eq(143)

    end

    it "can have multiple selects" do
      #Which countries are some kind of republic and achieved independence after 1945?
      countries = Country
        .where("governmentform LIKE '%Republic' AND indepyear > 1945")
      expect(countries.count).to eq(92)
    end
  end

  describe "Order" do
    it "can use order (class)" do
      # Which country has the shortest, non-null, life expectancy?
      country = Country
        .where.not(lifeexpectancy: nil)
        .order(:lifeexpectancy)
        .limit(1)
        .first
      expect(country.code).to eq('ZMB')
    end

    it "can use order" do
      # Which country has the highest life expectancy?
      country = Country
        .order('lifeexpectancy DESC')
        .limit(1)
        .first
      expect(country.code).to eq('FLK')
    end

    it "can use order" do
      #Which is the smallest country by area
      country = Country
        .order('surfacearea')
        .limit(1)
        .first
      expect(country.code).to eq('VAT')

    end

    it "can use order" do
      #which is the biggest country by area
      country = Country
        .order(surfacearea: :desc)
        .limit(1)
        .first
      expect(country.code).to eq('RUS')

    end

    it "can use order" do
      #Which is the smallest country by population
      country = Country
      .order(population: :asc)
      .limit(1)
      .first
      expect(country.code).to eq('ATA')
    end

    it "can use order" do
      #which is the biggest country by population
      country = Country
        .order(population: :desc)
        .limit(1)
        .first
      expect(country.code).to eq('CHN')

    end

    it "can combine order and limit (class)" do
      # Which 10 countries have the lowest life expectancy?
      # Hint: use pluck

      countries = Country
      .order(:lifeexpectancy)
      .limit(10)
      .pluck(:name)

      expected = ["Zambia", "Mozambique", "Malawi", "Zimbabwe", "Angola", "Botswana", "Rwanda", "Swaziland", "Niger", "Namibia"]

      expected.map do |country|
        expect(countries).to include(country)
      end
    end

    it "can combine order and limit" do
      #Which five countries have the lowest population density?
      expected = ["South Georgia and the South Sandwich Islands", "Bouvet Island", "Antarctica", "British Indian Ocean Territory", "Heard Island and McDonald Islands"]
      country_names = Country
        .order('population / surfacearea')
        .limit(5)
        .pluck(:name)
      expected.map do |country|
        expect(country_names).to include(country)
      end

    end

    it "can combine order and limit" do
      #which five countries have the highest population density?
      expected = ["Macao", "Monaco", "Hong Kong", "Singapore", "Gibraltar"]
      country_names = Country
        .order('population / surfacearea DESC')
        .limit(5)
        .pluck(:name)
      expected.map do |country|
        expect(country_names).to include(country)
      end

    end

    it "can combine order and limit" do
      #Which are the 10 smallest countries by area?
      expected = ["Holy See (Vatican City State)", "Monaco", "Gibraltar", "Tokelau", "Cocos (Keeling) Islands", "United States Minor Outlying Islands", "Macao", "Nauru", "Tuvalu", "Norfolk Island"]
      countries = Country
        .order(surfacearea)
        .limit(10)
        .pluck(:name)
      expected.map do |country|
        expect(countries).to include(country)
      end
    end
  end

  describe "Combining ActiveRecord and Plain Old Ruby (POR) (class)" do
    it "can simplify 'with' queries" do
      #Of the smallest 10 countries by population, which has the biggest gnp?

      countries = Country
        .order(:population)
        .limit(10)
      smallest_biggest = countries.max{|a,b| a.gnp <=> b.gnp}
      # smallest_biggest = countries.maximum(:gnp)

      expect(smallest_biggest.name).to eq("Holy See (Vatican City State)")
    end

    it "can simplify 'with' queries" do
      #Of the largest 10 countries by surfacearea, which has the smallest gnp

      countries = Country
        .order(surfacearea: :desc)
        .limit(10)
        smallest_biggest = countries.min{|a,b| a.gnp <=> b.gnp}
      expect(smallest_biggest.name).to eq("Antarctica")
    end

    it "can simplify 'with' queries" do
      #Of the biggest 10 countries by population, which has the biggest gnp?
      countries = Country
        .order(population: :desc)
        .limit(10)
        biggest_biggest = countries.max{|a, b| a.gnp <=> b.gnp}
      expect(biggest_biggest.name).to eq("United States")

    end

    it "can simplify 'aggregate' operations (class)" do
      #What is the sum of surface area of the 10 biggest countries in the world?
      countries = Country
        .order(surfacearea: :desc)
        .limit(10)
      # sum_total = countries.sum(:surfacearea)    #this may be a bug! research and report if neccessary
      sum_total = countries.pluck(:surfacearea).sum
      expect(sum_total).to eq(84183610.0)
    end

    it "can simplify 'aggregate' operations" do
      #What is the sum of surface area of the 10 least populated countries in the world?
      countries = Country
        .order(:population)
        .limit(10)
        sum_total = countries.pluck(:surfacearea).sum
      expect(sum_total).to eq(13132258.4)
    end
  end
end
