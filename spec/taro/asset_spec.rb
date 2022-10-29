# frozen_string_literal: true

require "spec_helper"

RSpec.describe Taro::Asset do
  let(:genesis) do
    genesis_point = Bitcoin::OutPoint.from_txid("01" * 32, 1)
    Taro::Genesis.new(
      prev_out: genesis_point,
      tag: "normal asset",
      metadata: ["010203"].pack("H*"),
      output_index: 1
    )
  end

  let(:script_key) do
    Bitcoin::Key.new(
      pubkey:
        "02a0afeb165f0ec36880b68e0baabd9ad9c62fd1a69aa998bc30e9a346202e078f"
    )
  end

  let(:asset) do
    fam_key =
      Bitcoin::Key.new(
        pubkey:
          "0214ac808afb3c8f1fd0cf0804b5e6494dbbfc47d633cfc36a3857e9e6c555a183"
      )
    sig =
      Schnorr::Signature.decode(
        "7a70d30bb4e3de62878eed22ff3a633fe4b678def84a290066c408f88615d570ac534407df4e5e4ee05772e5e00a4376361dfd6caa632a3d21306f68c3e39d29".htb
      )
    family_key =
      Taro::FamilyKey.new(
        Taro::KeyDescriptor.new(public_key: Bitcoin::Key.generate),
        fam_key,
        sig
      )
    described_class.new(genesis, 741, 0, 0, script_key, family_key)
  end

  describe "Genesis" do
    describe "#id" do
      it do
        expect(genesis_sample.id).to eq(
          "9333d8360be674dfae320b7ae16bd3b618726637fad107a1d2b248a3083061ca"
        )
        # check output index endian
        expect(genesis.id).to eq(
          "903b66d102304419811c42f9909516afe9ccd076df7e81b92df315ffc008ece6"
        )
      end
    end

    describe "#encode" do
      it do
        expect(genesis.encode.bth).to eq(
          "0101010101010101010101010101010101010101010101010101010101010101000000010c6e6f726d616c206173736574030102030000000100"
        )
      end
    end
  end

  describe "#commitment_key" do
    context "without family key" do
      let(:asset) { described_class.new(genesis, 741, 0, 0, script_key) }

      it do
        expect(asset.commitment_key.bth).to eq(
          "91e44dfb91766cc497745eeb2f10b45469f16198343e86edc57d2c6bb0a29abb"
        )
      end
    end

    context "with family key" do
      it "calculate H(asset id || script_key)" do
        expect(asset.commitment_key.bth).to eq(
          "7237f1b9081cc22856db59112c6dbb365c949b4e272e869afde1cf81723e2c5b"
        )
      end
    end
  end

  describe "#leaf" do
    subject(:leaf) { asset.leaf }

    it do
      expect(leaf.value.bth).to eq(
        "000100013a0101010101010101010101010101010101010101010101010101010101010101000000010c6e6f726d616c2061737365740301020300000001000201000303fd02e506680166006400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080200000920a0afeb165f0ec36880b68e0baabd9ad9c62fd1a69aa998bc30e9a346202e078f0a6014ac808afb3c8f1fd0cf0804b5e6494dbbfc47d633cfc36a3857e9e6c555a1837a70d30bb4e3de62878eed22ff3a633fe4b678def84a290066c408f88615d570ac534407df4e5e4ee05772e5e00a4376361dfd6caa632a3d21306f68c3e39d29"
      )
      expect(leaf.sum).to eq(741)
    end
  end
end
