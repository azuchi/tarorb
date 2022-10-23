# frozen_string_literal: true

module Taro
  # AssetCommitment represents the inner MS-SMT within the Taro protocol
  # committing to a set of assets under the same ID/family.
  # Assets within this tree, which are leaves represented as the serialized asset TLV payload,
  # are keyed by their `asset_script_key`.
  class AssetCommitment
    attr_reader :version, :asset_id, :tree, :assets

    # @param [Array[Taro::Asset]]
    # @raise [Taro::Error]
    def initialize(assets)
      max_version = 0
      asset_genesis = assets.first.genesis.id
      asset_family_key = assets.first.family_key
      @assets = assets
      @tree = MSSMT::Tree.new
      assets.each do |asset|
        unless asset.family_key == asset_family_key
          raise Taro::Error, "asset commitment: family key mismatch"
        end
        if asset.family_key.nil? && asset_genesis != asset.genesis.id
          raise Taro::Error, "asset commitment: genesis mismatch"
        end
        unless asset.family_key.nil?
          # TODO: There should be a valid Schnorr sig over the asset ID in the family key.
        end
        max_version = asset.version if asset.version > max_version
        @tree.insert(asset.commitment_key.bth, asset.leaf)
      end
      asset_id =
        (
          if asset_family_key.nil?
            asset_genesis
          else
            Bitcoin.sha256(asset_family_key.fam_key.xonly_pubkey.htb).bth
          end
        )

      @version = max_version
      @asset_id = asset_id
    end

    # Computes the root identifier required to commit to this specific asset commitment within the outer commitment,
    # also known as the Taro commitment.
    # @return [String]
    def root
      left = tree.root_node.left.node_hash
      right = tree.root_node.right.node_hash
      sum = [tree.root_node.sum].pack("Q>")
      Bitcoin.sha256(asset_id.htb + left + right + sum)
    end

    # Get taro commitment key which is insertion key for this specific asset commitment to include
    # in the Taro commitment MS-SMT.
    # @return [String]
    def taro_commitment_key
      asset_id
    end

    # Computes the leaf node for this specific asset commitment to include in the Taro commitment MS-SMT.
    # @return [MSSMT::LeafNode]
    def taro_commitment_leaf
      value = [version].pack("C") + root + [tree.root_node.sum].pack("Q>")
      MSSMT::LeafNode.new(value, tree.root_node.sum)
    end
  end
end
