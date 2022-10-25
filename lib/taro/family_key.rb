# frozen_string_literal: true

module Taro
  # FamilyKey is the tweaked public key that is used to associate assets together across distinct asset IDs,
  # allowing further issuance of the asset to be made possible.
  class FamilyKey
    attr_accessor :raw_key, :fam_key, :sig

    # Constructor
    # @param [Taro::KeyDescriptor] raw_key
    # @param [Bitcoin::Key] fam_key
    # @param [Schnorr::Signature] sig
    def initialize(raw_key, fam_key, sig)
      unless raw_key.is_a?(Taro::KeyDescriptor)
        raise ArgumentError, "raw_key must be Schnorr::Signature"
      end
      unless fam_key.is_a?(Bitcoin::Key)
        raise ArgumentError, "fam_key must be Bitcoin::Key"
      end
      unless sig.is_a?(Schnorr::Signature)
        raise ArgumentError, "sig must be Schnorr::Signature"
      end
      @raw_key = raw_key
      @fam_key = fam_key
      @sig = sig
    end

    # Encode tlv payload
    # @return [String]
    def encode
      fam_key.xonly_pubkey.htb + sig.encode
    end

    # Decode tlv value as FamilyKey
    # @param [String] payload
    # @return [Taro::FamilyKey]
    def self.decode(payload)
      fam_key = Bitcoin::Key.from_xonly_pubkey(payload[0...32].bth)
      sig = Schnorr::Signature.decode(payload[32..-1])
      FamilyKey.new(nil, fam_key, sig)
    end
  end
end
