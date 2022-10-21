# frozen_string_literal: true

module Taro
  module TLV
    # Taro TLV record
    class Record
      include Taro::Util
      attr_reader :type, :value

      # Constructor
      # @param [Integer] type TLV type.
      # @param [Object] value TLV value.
      def initialize(type, value)
        raise ArgumentError, "type must be integer" unless type.is_a?(Integer)
        if type < Taro::TLV::VERSION || Taro::TLV::ASSET_FAMILY_KEY < type
          raise ArgumentError, "unsupported type specified"
        end

        @type = type
        @value = value
      end

      # Serialize as TLV blob
      # @return [String]
      # @raise [Taro::Error] if type does not supported.
      def tlv
        buf = pack_big_size(type)
        case type
        when TLV::VERSION, TLV::ASSET_TYPE
          buf << pack_big_size(1) << [value].pack("C")
        when TLV::GENESIS, TLV::ASSET_FAMILY_KEY
          data = value.encode
          buf << pack_var_string(data)
        when TLV::AMOUNT
          v = pack_big_size(value)
          buf << pack_var_string(v)
        when TLV::PREV_ASSET_WITNESS
          data = [value.length].pack("C")
          data << value
            .map do |w|
              v = w.encode
              pack_big_size(v.bytesize) + v
            end
            .join
          buf << [data.bytesize].pack("C") << data
        when TLV::SPLIT_COMMITMENT
          # TODO
        when TLV::ASSET_SCRIPT_VERSION
          buf << pack_big_size(2) << [value].pack("n")
        when TLV::ASSET_SCRIPT_KEY
          buf << pack_big_size(32) << value.xonly_pubkey.htb
        else
          raise Error, "Unsupported type: #{type}"
        end
        buf
      end
    end
  end
end
