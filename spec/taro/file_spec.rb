# frozen_string_literal: true
require "spec_helper"

RSpec.describe Taro::File do
  describe "#decode" do
    subject(:file) do
      described_class.decode(
        File.read(
          fixture_path(
            "proof/026e552eef52663dcf984ad1443660a66923aca4c8b77240fb83114dbb0ea91269.taro"
          )
        )
      )
    end

    it do
      expect(file.version).to eq(0)
      expect(file.proofs.length).to eq(1)
      proof = file.proofs.first
      expect(proof.asset).to eq(asset_sample)
      expect(proof.inclusion_proof.output_index).to eq(0)
      expect(proof.inclusion_proof.internal_key.pubkey).to eq(
        "02fe3155363518765636316775fec96b57e454c3dd50ce19d18da5a1f9cf91b3a7"
      )
    end
  end
end
