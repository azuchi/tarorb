# frozen_string_literal: true

module Taro
  # Proof encodes all of the data necessary to prove a valid state transition for
  # an asset has occurred within an on-chain transaction.
  class Proof
    attr_reader :prev_out,
                :block_header,
                :anchor_tx,
                :merkle_proof,
                :asset,
                :inclusion_proof,
                :exclusion_proof,
                :split_root_proof,
                :additional_inputs

    def initialize(
      block_header:,
      anchor_tx:,
      merkle_proof:,
      prev_out: nil,
      asset: nil,
      inclusion_proof: nil,
      exclusion_proof: nil,
      split_root_proof: nil,
      additional_inputs: []
    )
      if prev_out && !prev_out.is_a?(Bitcoin::OutPoint)
        raise ArgumentError, "prev_out must be Bitcoin::OutPoint"
      end
      unless block_header.is_a?(Bitcoin::BlockHeader)
        raise ArgumentError, "block_header must be Bitcoin::BlockHeader"
      end
      unless anchor_tx.is_a?(Bitcoin::Tx)
        raise ArgumentError, "anchor_tx must be Bitcoin::Tx"
      end
      if asset && !asset.is_a?(Taro::Asset)
        raise ArgumentError, "asset must be Taro::Asset"
      end

      @prev_out = prev_out
      @block_header = block_header
      @anchor_tx = anchor_tx
      @merkle_proof = merkle_proof
      @asset = asset
      @inclusion_proof = inclusion_proof
      @exclusion_proof = exclusion_proof
      @split_root_proof = split_root_proof
      @additional_inputs = additional_inputs
    end
  end
end
