# frozen_string_literal: true

require "spec_helper"

RSpec.describe Taro::Asset do
  let(:genesis1) do
    genesis_point =
      Bitcoin::OutPoint.from_txid(
        "af2ed8bc93a28cba80bc3c8c55fc554bb7cb3f9071f59f87b83724d4e8b92ea9",
        1
      )
    Taro::Genesis.new(
      prev_out: genesis_point,
      tag: "testcoin",
      metadata: "metadata for test",
      output_index: 0
    )
  end

  let(:genesis2) do
    genesis_point = Bitcoin::OutPoint.from_txid("01" * 32, 1)
    Taro::Genesis.new(
      prev_out: genesis_point,
      tag: "normal asset",
      metadata: ["010203"].pack("H*"),
      output_index: 1
    )
  end

  describe "Genesis" do
    describe "#id" do
      it do
        expect(genesis1.id).to eq(
          "9333d8360be674dfae320b7ae16bd3b618726637fad107a1d2b248a3083061ca"
        )
        expect(genesis2.id).to eq(
          "903b66d102304419811c42f9909516afe9ccd076df7e81b92df315ffc008ece6"
        )
      end
    end
  end
end
