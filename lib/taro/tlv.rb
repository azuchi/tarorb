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

    autoload :Record, "taro/tlv/record"
  end
end
