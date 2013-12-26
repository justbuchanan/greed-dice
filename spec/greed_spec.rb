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


		it 'recognizes a straight' do
			expect(choices(straight)).should include([straight, STRAIGHT_VALUE])
		end

		it 'recognizes three-pair' do
			expect(choices(three_pair)).should include([three_pair, THREE_PAIR_VALUE])
		end
	end
end
