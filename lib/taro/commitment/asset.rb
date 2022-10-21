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
        @tree.insert(asset.commitment_key.bth, asset.leaf_node)
      end
      asset_id = asset_family_key.nil? ? asset_genesis : nil # TODO: family key based derivation

      @version = max_version
      @asset_id = asset_id
    end
  end
end
