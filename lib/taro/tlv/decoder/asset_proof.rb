# frozen_string_literal: true
module Taro
  module TLV
    # Decoder for asset proof TLV data.
    module AssetProofDecoder
      extend Taro::Util

      module_function

      # # Decode tlv as CommitmentProof.
      # @param [String] data
      # @return [Taro::Witness]
      def decode(data)
        buf = data.is_a?(StringIO) ? data : StringIO.new(data)
        type = unpack_big_size(buf)
        value = unpack_var_string(buf)
        record_value =
          case type
          when AssetProofType::VERSION
            value.unpack1("C")
          when AssetProofType::ASSET_ID
            value
          when AssetProofType::TYPE
            # TODO
            value
          end
        Record.new(type, record_value)
      end
    end
  end
end
