require_relative '../greed'
include Greed

describe Greed do
	context 'roll' do
		it 'returns the right # of dice' do
			expect(roll(3).length).to eq(3)
			expect(roll(5).length).to eq(5)
		end
	end

	context 'choices' do
		let(:straight) { (1..6).to_a }
		let(:three_pair) { [3, 3, 4, 4, 6, 6] }
		let(:example_roll) { [5, 4, 3, 1, 2, 1] }


		it 'recognizes a straight' do
			expect(choices(straight)).to include([straight, STRAIGHT_VALUE])
		end

		it 'recognizes three-pair' do
			expect(choices(three_pair)).to include([three_pair, THREE_PAIR_VALUE])
		end

		it 'allows splitting ones' do
			expect(choices(example_roll)).to include([[1], 100])
			expect(choices(example_roll)).to include([[1, 1], 200])
		end
	end
end
