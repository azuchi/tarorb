# frozen_string_literal: true

module Taro
  # Proof used along with an asset leaf to arrive at the root of the AssetCommitment MS-SMT.
  class AssetProof
    attr_reader :proof, :version, :asset_id

    # Constructor
    # @param [MSSMT::Proof] proof
    # @param [Integer] version
    # @param [String] asset_id
    def initialize(proof:, version:, asset_id:)
      @proof = proof
      @version = version
      @asset_id = asset_id
    end
  end
end
