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
  end
end
