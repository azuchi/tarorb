# frozen_string_literal: true
module Taro
  #
  class TaprootProof
    attr_reader :output_index,
                :internal_key,
                :commitment_proof,
                :tapscript_proof

    def initialize(
      output_index:,
      internal_key:,
      commitment_proof:,
      tapscript_proof:
    )
      @output_index = output_index
      @internal_key = internal_key
      @commitment_proof = commitment_proof
      @tapscript_proof = tapscript_proof
    end
  end
end
