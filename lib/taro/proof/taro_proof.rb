# frozen_string_literal: true

module Taro
  # Proof used along with an asset commitment leaf to arrive at the root of the TaroCommitment MS-SMT.
  class TaroProof
    attr_reader :proof, :version

    # Constructor
    # @param [MSSMT::Proof] proof
    # @param [Integer] version
    def initialize(proof:, version:)
      @proof = proof
      @version = version
    end
  end
end
