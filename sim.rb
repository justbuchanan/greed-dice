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



probs = (1..6).map { |dice_count| probability_of_not_busting(dice_count) }
puts "Probabilities: #{probs}"
