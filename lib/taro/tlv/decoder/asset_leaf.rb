module Taro
  module TLV
    module AssetLeafDecoder
      extend Taro::Util

      module_function

      # # Decode Asset Leaf TLV as Taro::TLV::Record
      # @param [String] data TLV value.
      # @return [Taro::TLV::Record]
      def decode(data)
        buf = data.is_a?(StringIO) ? data : StringIO.new(data)
        type = unpack_big_size(buf)
        value = buf.read(unpack_big_size(buf))
        record_value =
          case type
          when TLV::VERSION, TLV::ASSET_TYPE
            value.unpack1("C")
          when TLV::GENESIS
            Taro::Genesis.decode(value)
          when TLV::AMOUNT
            unpack_big_size(value)
          when TLV::PREV_ASSET_WITNESS
            num, _, value = value.unpack("CCa*")
            value = StringIO.new(value)
            num.times.map { PrevWitnessDecoder.decode(value) until value.eof? }
          when TLV::SPLIT_COMMITMENT
            # TODO
          when TLV::ASSET_SCRIPT_VERSION
            value.unpack1("n")
          when TLV::ASSET_SCRIPT_KEY
            Bitcoin::Key.from_xonly_pubkey(value.bth)
          when TLV::ASSET_FAMILY_KEY
            FamilyKey.decode(value)
          else
            raise Error, "Unsupported type: #{type}"
          end
        Record.new(type, record_value)
      end
    end
  end
end
