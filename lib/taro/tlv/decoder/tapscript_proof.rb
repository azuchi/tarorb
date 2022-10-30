# frozen_string_literal: true

module Taro
  module TLV
    # Decoder for tapscript preimage TLV data.
    module TapscriptProofDecoder
      extend Taro::Util

      module_function

      # # Decode tapscript preimage TLV as Taro::TLV::Record
      # @param [String] data TLV value.
      # @return [Taro::TLV::Record]
      def decode(data)
        buf = data.is_a?(StringIO) ? data : StringIO.new(data)
        type = unpack_big_size(buf)
        value = unpack_var_string(buf)
        record_value =
          case type
          when TLV::TapscriptProofType::PREIMAGE1,
               TLV::TapscriptProofType::PREIMAGE2
            sibling_type, rest = value.unpack("Ca*")
            TapscriptPreimage.new(sibling_type, unpack_var_string(rest))
          when TLV::TapscriptProofType::BIP86
            value.unpack1("C") == 1
          end
        Record.new(type, record_value)
      end
    end
  end
end
