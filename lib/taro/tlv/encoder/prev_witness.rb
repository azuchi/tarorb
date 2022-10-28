# frozen_string_literal: true

module Taro
  module TLV
    # Encoder for previous witness TLV record.
    module PrevWitnessEncoder
      extend Taro::Util

      module_function

      # Encode prev witness as tlv.
      # @param [Taro::Witness] witness
      # @return [String] tlv
      def encode(witness)
        data = (witness.prev_id ? witness.prev_id.tlv : "")
        #TODO: tx_witness, split_commitment
        pack_big_size(data.bytesize) + data
      end
    end
  end
end
