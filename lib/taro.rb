# frozen_string_literal: true

require "bitcoin"
require_relative "taro/version"
require "mssmt"

# Taro library for issuing assets on the Bitcoin blockchain.
module Taro
  MARKER_TAG = "taro"
  MARKER = Bitcoin.sha256(MARKER_TAG)

  class Error < StandardError
  end
  autoload :Util, "taro/util"
  autoload :TLV, "taro/tlv"
  autoload :KeyDescriptor, "taro/key_descriptor"
  autoload :FamilyKey, "taro/family_key"
  autoload :Genesis, "taro/asset"
  autoload :Asset, "taro/asset"
  autoload :Witness, "taro/witness"
  autoload :PrevID, "taro/witness"
  autoload :AssetCommitment, "taro/commitment/asset"
  autoload :TaroCommitment, "taro/commitment/taro"
  autoload :SplitCommitment, "taro/commitment/split"

  # Proof
  autoload :AssetProof, "taro/proof/asset_proof"
  autoload :CommitmentProof, "taro/proof/commitment_proof"
  autoload :TaprootProof, "taro/proof/taproot_proof"
  autoload :TaroProof, "taro/proof/taro_proof"
  autoload :TxMerkleProof, "taro/proof/tx_merkle_proof"
  autoload :Proof, "taro/proof"

  autoload :TapscriptPreimage, "taro/tapscript_proof"
  autoload :File, "taro/file"
  autoload :Address, "taro/address"
end
