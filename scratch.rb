
	data = '/Users/apple/Documents/workspace/ml-100k/u.data'
	info = '/Users/apple/Documents/workspace/ml-100k/u.info'

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

	popularity = Hash.new("n/a")
	items_by_user = Array.new([])
	ratings_by_user = Array.new([])

	#fix this
	i = 0
	item_idx.each {|idx|
		review_count[idx-1] += 1
		total_stars[idx-1] += item_rating[i]
		if items_by_user[user_idx[i]-1] == nil
			items_by_user[user_idx[i]-1] = [idx]
			ratings_by_user[user_idx[i]-1] = [item_rating[i]]
		else
			items_by_user[user_idx[i]-1] = items_by_user[user_idx[i]-1].push(idx)
			ratings_by_user[user_idx[i]-1] = ratings_by_user[user_idx[i]-1].push(item_rating[i])
		end
		i += 1
	}


	range = Math::log(review_count.max) - Math::log(review_count.min)

	item_idx.each {|idx|
		popularity[idx] = (Math::log(review_count[idx-1])/range*100).round
	}

	popularity = popularity.sort_by{|k,v| v}.reverse!

	puts popularity

(0..user_count-1).each {|x| 
	reviewed1 = items_by_user[5]
	reviewed2 = items_by_user[x]
	ratings1 = ratings_by_user[5]
	ratings2 = ratings_by_user[x] 

	avg1 = ratings1.inject{ |sum, el| sum + el }.to_f / ratings1.size
	avg2 = ratings2.inject{ |sum, el| sum + el }.to_f / ratings2.size
	intersect = reviewed1&reviewed2

	if intersect.size == 0
		similarity = 0
	else

		temp = intersect.size-1

		numerator = (0..temp).inject {|sum,el| 
			sum + (ratings1[reviewed1.index(intersect[el])]-avg1)*(ratings2[reviewed2.index(intersect[el])]-avg2)
		} 

		term1 = (0..temp).inject {|sum,el| 
			sum + (ratings1[reviewed1.index(intersect[el])]-avg1)**2
		}

		term2 = (0..temp).inject {|sum,el|
			sum + (ratings2[reviewed2.index(intersect[el])]-avg2)**2
		}

		similarity = [temp+1,20].min/20*numerator/Math::sqrt(term1)/Math::sqrt(term2)

	end

	if similarity>0.5
		 puts "id = #{x}, similarity = #{similarity}"
	end
}