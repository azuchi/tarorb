# frozen_string_literal: true

require "bitcoin"
require_relative "taro/version"
require "mssmt"

# Taro library for issuing assets on the Bitcoin blockchain.
module Taro
  class Error < StandardError
  end
  autoload :Util, "taro/util"
  autoload :TLV, "taro/tlv"
  autoload :KeyDescriptor, "taro/key_descriptor"
  autoload :FamilyKey, "taro/family_key"
  autoload :Genesis, "taro/asset"
  autoload :Asset, "taro/asset"
  autoload :Witness, "taro/witness"
  autoload :AssetCommitment, "taro/commitment/asset"
  autoload :TaroCommitment, "taro/commitment/taro"
  autoload :SplitCommitment, "taro/commitment/split"
end
