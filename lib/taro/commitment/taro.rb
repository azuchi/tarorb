# frozen_string_literal: true

module Taro
  # TaroCommitment is the outer MS-SMT within the Taro protocol committing to a set of asset commitments.
  class TaroCommitment
    attr_reader :version, :tree, :asset_commitments

    def initialize(asset_commitments)
      @tree = MSSMT::Tree.new
      @asset_commitments = asset_commitments
      @version = 0
      @asset_commitments.each do |asset|
        @version = asset.version if asset.version > @version
        key = asset.taro_commitment_key
        leaf = asset.taro_commitment_leaf
        @tree.insert(key.bth, leaf)
      end
    end

    # Return new TapLeaf for this TaroCommitment.
    # @return [Bitcoin::Taproot::LeafNode]
    def tap_leaf
      sum = [tree.root_node.sum].pack("Q>")
      script = [version].pack("C") + Taro::MARKER + tree.root_hash + sum
      Bitcoin::Taproot::LeafNode.new(Bitcoin::Script.parse_from_payload(script))
    end

    # Build the tapscript root for this TaroCommitment.
    # @param [Bitcoin::Key] internal_key Internal public key using in taproot.
    # @param [String] sibling The hash of sibling node with this leaf.
    # @return [Bitcoin::Script] ScriptPubkey for taproot.
    def to_taproot(internal_key, sibling = nil)
      # TODO: sibling support
      builder =
        Bitcoin::Taproot::SimpleBuilder.new(
          internal_key.xonly_pubkey,
          [tap_leaf]
        )
      builder.build
    end
  end
end
