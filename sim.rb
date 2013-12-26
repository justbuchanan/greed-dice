require_relative './greed'

include Greed



dice = roll(6)
p "dice: #{dice}"
cnt = counts(dice)
p "counts: #{cnt}"

p choices(dice)
