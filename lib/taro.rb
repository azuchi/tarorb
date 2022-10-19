# frozen_string_literal: true

require "bitcoin"
require_relative "taro/version"

# Taro library for issuing assets on the Bitcoin blockchain.
module Taro
  class Error < StandardError
  end
  autoload :Util, "taro/util"
  autoload :KeyDescriptor, "taro/key_descriptor"
  autoload :FamilyKey, "taro/family_key"
  autoload :Asset, "taro/asset"
  autoload :AssetCommitment, "taro/commitment/asset"
  autoload :TaroCommitment, "taro/commitment/taro"
end
