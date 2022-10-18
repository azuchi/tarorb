# frozen_string_literal: true

module Taro
  # FamilyKey is the tweaked public key that is used to associate assets together across distinct asset IDs,
  # allowing further issuance of the asset to be made possible.
  class FamilyKey
    attr_accessor :raw_key, :fam_key, :sig

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
    end
  end
end
