require 'pry'


module Greed
	STRAIGHT_VALUE = 1000
	THREE_PAIR_VALUE = 800	#FIXME? ????


	# given a number +n+ of dice to roll, returns an array of 'dice'
	def roll(n)
		n.times.map { 1 + rand(5) }
	end


	# returns a hash of die-value, count pairs
	def counts(dice)
		(1..6).inject({}) do |counts, val|
			c = dice.count(val)
			counts[val] = c if c > 0
			counts
		end
	end


	# NOTE: doesn't handle straights or 3 of a kind!
	def evaluate_dice(dice)
		counts(dice).inject(0) do |score, pair|
			die = pair[0]
			count = pair[1]
			if count >= 3
				s = die == 1 ? 1000 : die * 100
				s = s * (count - 1)
				score = score + s
			elsif die == 5
				score = score + 50 * count
			elsif die == 1
				score = score + 100 * count
			end
			score
		end
	end


	# takes in a sorted array of dice and returns an array of 'choices'
	# each choice is a ([dice], value) tuple
	# it may not return all choices, but any choice not returned must have an objectively-better counterpart in the returned choice set
	def choices(dice)
		if dice.length > 6
			raise ArgumentError, "No more than six dice allowed"
		end

		choices = []
		counts = counts(dice)

		# straight
		if counts.size == 6
			choices << [dice, STRAIGHT_VALUE]
			return choices
		end

		# three pair
		if counts.size == 3 && counts.inject(true) { |possible, pair| possible && pair[1] == 2 }
			choices << [dice, THREE_PAIR_VALUE]
			return choices
		end


		# discard anything that's not a 1 or 5 or has a count less than 3
		counts = counts.inject({}) do |filtered, pair|
			die = pair.first
			count = pair[1]
			if die == 5 || die == 1 || count >= 3
				filtered[die] = count
			end
			filtered
		end


		options_by_index = counts.inject([]) do |opts, pair|
			die = pair.first
			count = pair[1]
			if die == 5 || die == 1
				opts << (0..count).to_a
			else
				opts << [0] + (3..count).to_a
			end
			opts
		end

		choices_by_index = [0] * counts.size

		# advances to the next combination
		# returns false if it was unable to get a new combination
		tumble = lambda do
			(0..choices_by_index.length-1).reverse_each do |index|
				if choices_by_index[index] < options_by_index[index].length - 1
					choices_by_index[index] = choices_by_index[index] + 1

					# reset all choices after the one just tumbled
					for index in (index+1..choices_by_index.length-1)
						choices_by_index[index] = 0
					end
					return true
				end
			end

			return false
		end

		# builds the choice from
		extract = lambda do
			choice = []
			(0..choices_by_index.length-1).each do |i|
				choice += [ counts.keys[i] ] * options_by_index[i][ choices_by_index[i] ]
			end
			[choice, evaluate_dice(choice)]
		end

		# add the choice to the set of possible
		while tumble.call()
			choices << extract.call()
		end


		choices
	end
end
