MOVIES-1 DESIGN:

FUNCTION COMPLEXITY:

load_data - O(n)

popularity(movie_id) - O(1)

popularity_list - O(nlogn)

similarity(user1,user2) - O(n)

most_similar(u) - O(nm) (n: # of users - 1; m = # of movies a user reviewed


INDEX DEFINATION:

popularity index = 1/log(# of reviews)

similarity index = min(intersect(# of user1 reviewed movies, # of user2 reviewed movies), 20)/20 * pearson correlation similarity
Cutoff similarity index value for being "most similar": 0.5
