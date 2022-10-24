# frozen_string_literal: true

module Taro
  module TLV
    # Encoder for Asset Leaf TLV record.
    module AssetLeafEncoder
      extend Taro::Util

      module_function

      # Encode record to Asset Leaf TLV
      # @param [Taro::TLV::Record]
      # @return [String] TLV value.
      def encode(record)
        buf = pack_big_size(record.type)
        case record.type
        when TLV::VERSION, TLV::ASSET_TYPE
          buf << pack_big_size(1) << [record.value].pack("C")
        when TLV::GENESIS, TLV::ASSET_FAMILY_KEY
          data = record.value.encode
          buf << pack_var_string(data)
        when TLV::AMOUNT
          v = pack_big_size(record.value)
          buf << pack_var_string(v)
        when TLV::PREV_ASSET_WITNESS
          data = [record.value.length].pack("C")
          data << record
            .value
            .map do |w|
              v = w.encode
              pack_big_size(v.bytesize) + v
            end
            .join
          buf << [data.bytesize].pack("C") << data
        when TLV::SPLIT_COMMITMENT
          # TODO
        when TLV::ASSET_SCRIPT_VERSION
          buf << pack_big_size(2) << [record.value].pack("n")
        when TLV::ASSET_SCRIPT_KEY
          buf << pack_big_size(32) << record.value.xonly_pubkey.htb
        else
          raise Error, "Unsupported type: #{record.type}"
        end
        buf
      end
    end
  end
end
