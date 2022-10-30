# frozen_string_literal: true

module Taro
  module TLV
    # Decoder for Taro proof TLV data.
    module TaroProofDecoder
      extend Taro::Util

      module_function

      # # Decode Asset Leaf TLV as Taro::TLV::Record
      # @param [String] data TLV value.
      # @return [Taro::TLV::Record]
      def decode(data)
        buf = data.is_a?(StringIO) ? data : StringIO.new(data)
        type = unpack_big_size(buf)
        value = unpack_var_string(buf)
        record_value =
          case type
          when TaroProofType::PROOF
            MSSMT::CompressedProof.decode(value).decompress
          when TaroProofType::VERSION
            value.unpack1("C")
          else
            raise Taro::Error, "Unsupported type: #{type}"
          end
        Record.new(type, record_value)
      end
    end
  end
end
