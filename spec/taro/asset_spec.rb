# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Taro::Asset do
  describe 'Genesis' do
    describe '#id' do
      it 'calculate asset id' do
        genesis_point =
          Bitcoin::OutPoint.from_txid(
            'af2ed8bc93a28cba80bc3c8c55fc554bb7cb3f9071f59f87b83724d4e8b92ea9',
            1
          )

        genesis =
          Taro::Genesis.new(
            prev_out: genesis_point,
            tag: 'testcoin',
            metadata: 'metadata for test',
            output_index: 0
          )
        expect(genesis.id).to eq(
          '9333d8360be674dfae320b7ae16bd3b618726637fad107a1d2b248a3083061ca'
        )
      end
    end
  end
end
