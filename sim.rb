require_relative './greed'

include Greed


# this player keeps rolling until they get 500+ for the round
# also they always choose the first option
player = lambda do |player_id, scores, choices, round_running_total|
	choice = choices[0]
	return choice, !(round_running_total + choice[1] >= 500)
end


wins = {}

for i in (0..10000) do
	game = Game.new([
		player,
		player,
		player
	])
	game.run()

	winner = game.rankings[0]
	wins[winner] ||= 0
	wins[winner]++
end

puts "wins: #{wins}"
