# frozen_string_literal: true

module Taro
  module TLV
    # Encoder for Taro address TLV record.
    module AddressEncoder
      extend Taro::Util

      module_function

      # Encode record to Taro address TLV
      # @param [Taro::TLV::Record]
      # @return [String] TLV value.
      def encode(record)
        buf = pack_big_size(record.type)
        case record.type
        when AddrType::VERSION, AddrType::ASSET_TYPE
          buf << pack_big_size(1) << [record.value].pack("C")
        when AddrType::ASSET_GENESIS
          data = record.value.encode
          buf << pack_var_string(data)
        when AddrType::FAM_KEY, AddrType::SCRIPT_KEY, AddrType::INTERNAL_KEY
          buf << pack_big_size(32) << record.value.xonly_pubkey.htb
        when AddrType::AMOUNT
          v = pack_big_size(record.value)
          buf << pack_var_string(v)
        else
          raise Taro::Error, "Unsupported type: #{type}"
        end
        buf
      end
    end
  end
end
