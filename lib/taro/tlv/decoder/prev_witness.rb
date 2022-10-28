# frozen_string_literal: true

module Taro
  module TLV
    # Decoder for previous witness TLV data.
    module PrevWitnessDecoder
      extend Taro::Util

      module_function

      # Decode tlv as prev witness.
      # @param [String] data
      # @return [Taro::Witness]
      def decode(data)
        buf = data.is_a?(StringIO) ? data : StringIO.new(data)
        type = unpack_big_size(buf)
        value = unpack_var_string(buf)
        record_value =
          case type
          when WitnessType::PREV_ASSET_ID
            PrevID.decode(value)
          when WitnessType::ASSET_WITNESS
            # TODO
          when WitnessType::SPLIT_COMMITMENT_PROOF
            # TODO
          end
        # TODO: tx_witness, split_commitment
        Taro::Witness.new(record_value)
      end
    end
  end
end
