require_relative './greed'

include Greed


# dice = roll(6)
# cnt = counts(dice)
# choices = choices(dice).sort { |a, b| a[0].length <=> b[0].length }
# filtered = filter_choices(choices).sort { |a, b| a[0].length <=> b[0].length }

# puts "Dice: #{dice}\n"
# puts "Counts: #{cnt}\n"

# puts "Choices:"
# choices.each { |choice| p choice }
# puts "\n"

# puts "Filtered:"
# filtered.each { |choice| p choice }
# puts "\n"



# probs = (1..6).map { |dice_count| probability_of_not_busting(dice_count) }
# puts "Probabilities: #{probs}"


# this player keeps rolling until they get 500+ for the round
# also they always choose the first option
player = lambda do |player_id, scores, choices, round_running_total|
	choice = choices[0]
	return choice, !(round_running_total + choice[1] >= 500)
end



game = Game.new([
	player,
	player,
	player
])


game.run()



# dice_count = 6
# score = 0
# while true
# 	dice = roll(dice_count)
# 	puts "Rolled: #{dice}"
# 	choices = choices(dice)
# 	if choices.length == 0
# 		puts "Bust! :("
# 		break
# 	end

# 	choice = choices.sort do |a, b|
# 		b[1] <=> a[1]
# 	end.first
# 	dice_count -= choice[0].length
# 	score += choice[1]
# 	puts "chose #{choice[0]} for a score of #{choice[1]}, total is now #{score}"

# 	if dice_count == 0
# 		dice_count = 6
# 		puts "get all the dice again!"
# 	end

# 	puts ""
# end




