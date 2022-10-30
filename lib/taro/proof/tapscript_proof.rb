# frozen_string_literal: true
module Taro
  # Proof of a Taproot output not including a Taro commitment.
  # Taro commitments must exist at a leaf with depth 0 or 1,
  # so we can guarantee that a Taro commitment doesn't exist
  # by revealing the preimage of one node at depth 0 or two nodes at depth 1.
  class TapscriptProof
    attr_reader :tap_preimage1, :tap_preimage2, :bip86

    # Constructor
    # @param[Taro::TapscriptPreimage] tap_preimage1
    # @param[Taro::TapscriptPreimage] tap_preimage2
    # @param [Boolean] bip86
    def initialize(tap_preimage1:, tap_preimage2:, bip86:)
      @tap_preimage1 = tap_preimage1
      @tap_preimage2 = tap_preimage2
      @bip86 = bip86
    end
  end
end
