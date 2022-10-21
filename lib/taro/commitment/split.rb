# frozen_string_literal: true

module Taro
  # SplitCommitment represents the asset witness for an asset split.
  class SplitCommitment
    attr_reader :proof, :root_asset

    # Constructor
    # @param [Array[String]] Proof for a particular asset split resulting from a split commitment.
    # @param [Taro::Asset] root_asset Asset containing the root of the split commitment tree from
    # which the +proof+ above was computed from.
    def initialize(proof, root_asset)
      @proof = proof
      @root_asset = root_asset
    end
  end
end
