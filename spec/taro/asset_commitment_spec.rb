# frozen_string_literal: true

require "spec_helper"

RSpec.describe Taro::AssetCommitment do
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
    Taro::Asset.new(genesis, 741, 0, 0, script_key, family_key)
  end

  describe "#new" do
    it do
      asset_commitment = described_class.new([asset])
      expect(asset_commitment.tree.root_hash.bth).to eq(
        "406785de1d71bb5cf9d1c1865835ba19cd769ff3b0755a1f3eaa5a14881ce226"
      )
      expect(asset_commitment.root.bth).to eq(
        "2b87151d52d4ab61f5beabce7ef57de1c85c749be01dd8895e96e930057e6a28"
      )
      taro_commitment = Taro::TaroCommitment.new([asset_commitment])
      expect(taro_commitment.tree.root_hash.bth).to eq(
        "c0070dca12dbfda6ccda14b70661b1b31867c6cdd763fe6abc65276f3b514c64"
      )
    end
  end
end
