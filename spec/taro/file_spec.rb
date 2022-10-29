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
    end
  end
end
