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
				score + (die == 1 ? 1000 : die * 100) * (count - 2)
			elsif die == 5
				score + 50 * count
			elsif die == 1
				score + 100 * count
			end
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


	# given an array of ([choice], value) tuples, returns an array with objectively poorer choices removed
	# for a given amount of dice used up, only keeps the choice that gets the highest score
	# for example: you could keep a 1 or you could keep a 5.  If you want to keep just one die, which one do you choose?
	def filter_choices(choices)
		# put them in a hash with key == die count and value == array of choice tuples
		by_die_count = choices.inject({}) do |by_die_count, choice_tuple|
			choice = choice_tuple[0]
			cnt = choice.length
			by_die_count[cnt] ||= []
			by_die_count[cnt] << choice_tuple
			by_die_count
		end

		# take only the highest-value choice for each die count
		by_die_count.inject([]) do |filtered, pair|
			die_count = pair[0]
			choices = pair[1]
			filtered << choices.sort do |a, b|
				b[1] <=> a[1]
			end.first
			filtered
		end
	end


	def probability_of_not_busting(dice_count, num_trials = 10000, recalculate = false)
		@cached_probabilities ||= {}

		# return cached value
		if @cached_probabilities[dice_count] && !recalculate
			return @cached_probabilities[dice_count]
		end

		successes = 0
		num_trials.times do
			if choices(roll(dice_count)).length > 0
				successes = successes + 1.0
			end
		end
		@cached_probabilities[dice_count] = successes / num_trials
	end
end
