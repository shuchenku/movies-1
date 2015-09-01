class MovieData

	def initialize()
		@popularity_hash = Hash.new("n/a")
		@items_by_user = Array.new([])
		@popularity_hash = Hash.new("n/a")
		@users_reviewed = Array.new
		@users_ratings = Array.new

	end

	def load_data()
		data = 'ml-100k/u.data'
		info = 'ml-100k/u.info'
		h = []

		File.readlines(data).each do |line|
			h.push(line.split(' ').map{|x| x.to_i})
		end

		item_count = File.readlines(info)[1].split[0].to_i
		user_count = File.readlines(info)[0].split[0].to_i
		user_idx = h.transpose[0]
		item_idx = h.transpose[1]
		item_rating = h.transpose[2]
		review_count = Array.new(item_count){0}
		total_stars = Array.new(item_count){0}
		@users_reviewed = Array.new(user_count){[]}
		@users_ratings = Array.new(user_count) {[]}

		(0..item_idx.size-1).each {|i|
			review_count[item_idx[i]-1] += 1
			total_stars[item_idx[i]-1] += item_rating[i]

			@users_reviewed[user_idx[i]-1] << item_idx[i]
			@users_ratings[user_idx[i]-1] << item_rating[i]
		}

		range = Math::log(review_count.max) - Math::log([review_count.min,1].max)

		item_idx.each {|idx|
			@popularity_hash[idx] = (Math::log(review_count[idx-1])/range*100).round
		}
	end

	def popularity(movie_id)
		puts "Movie ID: #{movie_id};\t Popularity Index: #{@popularity_hash[movie_id]}"
	end

	def popularity_list(print)
		test = @popularity_hash.sort_by{|k,v| v}.reverse

		if print == true
			puts "\nMost popular movies (descending):"
			test.each {|row| popularity(row[0])}
		end
		return test
	end

	def similarity(user1,user2)
	
		intersect = @users_reviewed[user1-1]&@users_reviewed[user2-1]

		if intersect.size == 0
			sim = 0
		else
			temp = intersect.size-1
			numerator = (0..temp).inject(0) {|sum,el| 
				subarray1 = @users_ratings[user1-1]
				subarray2 = @users_ratings[user2-1]
				sum + (subarray1[@users_reviewed[user1-1].index(intersect[el])])*(subarray2[@users_reviewed[user2-1].index(intersect[el])])
			} 

			term1 = (0..temp).inject(0) {|sum,el| 
				subarray = @users_ratings[user1-1]
				sum + (subarray[@users_reviewed[user1-1].index(intersect[el])])**2
			}

			term2 = (0..temp).inject(0) {|sum,el|
				subarray = @users_ratings[user2-1]
				sum + (subarray[@users_reviewed[user2-1].index(intersect[el])])**2
			}

			sim = [temp+1,20].min/20*numerator/Math::sqrt(term1)/Math::sqrt(term2)
		end

		return sim
	end

	def most_similar(u)
		puts "\nMost similar users (Modified Pearson Correlation):"
		idx = *(0..@users_ratings.size-1)
		other_idx = idx-[u]
		other_idx.each {|i|
			sim  = similarity(u,i)
			if sim>0.5
				puts "User IDs = #{u+1},#{i+1};\tSimilarity = #{sim.round(5)}"
			end
		}
	end
end


