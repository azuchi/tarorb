# frozen_string_literal: true

module Taro
  # Type Length Value package
  module TLV
    # https://github.com/Roasbeef/bips/blob/bip-taro/bip-taro.mediawiki#Asset_Leaf_Format
    VERSION = 0
    ASSET_ID = 1 # TODO: see https://github.com/lightninglabs/taro/blob/main/asset/records.go#L19-L24
    GENESIS = 1
    ASSET_TYPE = 2
    AMOUNT = 3
    LOCKTIME = 4
    RELATIVE_LOCKTIME = 5
    PREV_ASSET_WITNESS = 6
    SPLIT_COMMITMENT = 7
    ASSET_SCRIPT_VERSION = 8
    ASSET_SCRIPT_KEY = 9
    ASSET_FAMILY_KEY = 10

    module WitnessType
      PREV_ASSET_ID = 0
      ASSET_WITNESS = 1
      SPLIT_COMMITMENT_PROOF = 2
    end

    module ProofType
      PREV_OUT = 0
      BLOCK_HEADER = 1
      ANCHOR_TX = 2
      MERKLE_PROOF = 3
      ASSET_LEAF = 4
      INCLUSION_PROOF = 5
      EXCLUSION_PROOF = 6
      SPLIT_ROOT_PROOF = 7
      ADDITIONAL_INPUTS = 8
    end

    module TaprootProofType
      OUTPUT_INDEX = 0
      INTERNAL_KEY = 1
      COMMITMENT_PROOF = 2
      TAPSCRIPT_PROOF = 3
    end

    module CommitmentProofType
      ASSET_PROOF = 0
      TARO_PROOF = 1
      TAP_SIBLING_PREIMAGE = 2
    end

    module AssetProofType
      VERSION = 0
      ASSET_ID = 1
      TYPE = 2
    end

    module TapscriptProofType
      PREIMAGE1 = 0
      PREIMAGE2 = 1
      BIP86 = 2
    end

    module TaroProofType
      VERSION = 0
      TYPE = 1
    end

    autoload :Record, "taro/tlv/record"
    autoload :AssetLeafEncoder, "taro/tlv/encoder/asset_leaf"
    autoload :AssetLeafDecoder, "taro/tlv/decoder/asset_leaf"
    autoload :PrevWitnessEncoder, "taro/tlv/encoder/prev_witness"
    autoload :PrevWitnessDecoder, "taro/tlv/decoder/prev_witness"
    autoload :ProofDecoder, "taro/tlv/decoder/proof"
    autoload :TaprootProofDecoder, "taro/tlv/decoder/taproot_proof"
    autoload :AssetProofDecoder, "taro/tlv/decoder/asset_proof"
    autoload :CommitmentProofDecoder, "taro/tlv/decoder/commitment_proof"
  end
end
