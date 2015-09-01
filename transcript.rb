load 'movie_data.rb'

test = MovieData.new
test.load_data()

temp = Array.new
temp = test.popularity_list(false);

puts "Popularity top 10:\n"
temp[(0..9)].each {|row| test.popularity(row[0])}

puts "\nPopularity bottom 10:\n"
temp[(temp.size-10..temp.size-1)].each {|row| test.popularity(row[0])}

test.most_similar(0)