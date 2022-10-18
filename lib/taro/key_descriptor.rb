# frozen_string_literal: true

module Taro
  KEY_FAMILY_MULTISIG = 0
  KEY_FAMILY_REVOCATION_BASE = 1
  KEY_FAMILY_HTLC_BASE = 2
  KEY_FAMILY_PAYMENT_BASE = 3
  KEY_FAMILY_DELAY_BASE = 4
  KEY_FAMILY_REVOCATION_ROOT = 5
  KEY_FAMILY_NODE_KEY = 6
  KEY_FAMILY_STATIC_BACKUP = 7
  KEY_FAMILY_TOWER_SESSION = 8
  KEY_FAMILY_TOWER_ID = 9

  # KeyLocator is a two-tuple that can be used to derive any key that has ever
  # been used under the key derivation mechanisms described in this file.
  class KeyLocator
    attr_reader :key_family, :index

    # @param [Integer] key_family Family is the family of key being identified.
    # @param [Integer] index The precise index of the key being identified.
    def initialize(key_family, index)
      @key_family = key_family
      @index = index
    end
  end

  # KeyDescriptor wraps a key locator and also optionally includes a public key.
  class KeyDescriptor
    attr_accessor :key_locator, :public_key

    # @param [Taro::KeyLocator] key_locator Key Locator is the internal Key Locator of the descriptor.
    # @param [Bitcoin::Key] public_key Optional public key that fully describes a target key.
    # If this is nil, the key_locator must not be empty.
    # @raise [ArgumentError]
    def initialize(key_locator: nil, public_key: nil)
      if public_key.nil? && key_locator.nil?
        raise ArgumentError, "key_locator must not be nil"
      end

      @locator = key_locator
      @public_key = public_key
    end
  end
end
