# frozen_string_literal: true

module Taro
  #  Full commitment proof for an asset. It can either prove inclusion or exclusion of an asset within a Taro commitment.
  class CommitmentProof
    attr_reader :asset_proof, :taro_proof, :tap_sibling_preimage

    # Constructor
    # @param [Taro::AssetProof] asset_proof
    # @param [Taro::TaroProof] taro_proof
    # @param [Taro]
    def initialize(asset_proof:, taro_proof:, tap_sibling_preimage:)
      @asset_proof = asset_proof
      @taro_proof = taro_proof
      @tap_sibling_preimage = tap_sibling_preimage
    end
  end
end
