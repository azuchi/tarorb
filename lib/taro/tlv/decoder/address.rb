# frozen_string_literal: true
module Taro
  module TLV
    # Decoder for Taro address TLV data.
    module AddressDecoder
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
          when AddrType::VERSION, AddrType::ASSET_TYPE
            value.unpack1("C")
          when AddrType::ASSET_GENESIS
            Taro::Genesis.decode(value)
          when AddrType::FAM_KEY, AddrType::SCRIPT_KEY, AddrType::INTERNAL_KEY
            Bitcoin::Key.from_xonly_pubkey(value.bth)
          when AddrType::AMOUNT
            unpack_big_size(value)
          else
            raise Taro::Error, "Unsupported type: #{type}"
          end
        Record.new(type, record_value)
      end
    end
  end
end
