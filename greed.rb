
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
		counts = counts.map do |die, count|
			if die != 5 && die != 1 && count < 3
				nil
			else
				{ die => count }
			end
		end



		#### each choice is an array of numbers ()
		# [1, 1, 1] => 1000
		# [a, a, a] => a * 100
		# 1 => 100
		# 5 => 50

		choices
	end
end
