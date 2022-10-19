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
        # check output index endian
        expect(genesis2.id).to eq(
          "903b66d102304419811c42f9909516afe9ccd076df7e81b92df315ffc008ece6"
        )
      end
    end

    describe "#encode" do
      it do
        expect(genesis2.encode.bth).to eq(
          "0101010101010101010101010101010101010101010101010101010101010101000000010c6e6f726d616c206173736574030102030000000100"
        )
      end
    end
  end

  describe "#commitment_key" do
    let(:script_key) do
      Bitcoin::Key.new(
        pubkey:
          "02a0afeb165f0ec36880b68e0baabd9ad9c62fd1a69aa998bc30e9a346202e078f"
      )
    end

    context "without family key" do
      let(:asset) { described_class.new(genesis2, 741, 0, 0, script_key) }

      it do
        expect(asset.commitment_key.bth).to eq(
          "91e44dfb91766cc497745eeb2f10b45469f16198343e86edc57d2c6bb0a29abb"
        )
      end
    end

    context "with family key" do
      let(:asset) do
        family_key =
          Taro::FamilyKey.new(
            Taro::KeyDescriptor.new(public_key: Bitcoin::Key.generate),
            Bitcoin::Key.generate,
            Schnorr::Signature.new(0, 0)
          )
        described_class.new(genesis2, 741, 0, 0, script_key, family_key)
      end

      it "calculate H(asset id || script_key)" do
        expect(asset.commitment_key.bth).to eq(
          "7237f1b9081cc22856db59112c6dbb365c949b4e272e869afde1cf81723e2c5b"
        )
      end
    end
  end
end
