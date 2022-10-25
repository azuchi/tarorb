module Taro
  module TLV
    module CommitmentProofDecoder
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
          when CommitmentProofType::ASSET_PROOF
            buf = StringIO.new(value)
            data = []
            data << AssetProofDecoder.decode(buf) until buf.eof?
            data
          when CommitmentProofType::TARO_PROOF
            value
          when CommitmentProofType::TAP_SIBLING_PREIMAGE
            # TODO
          end
        Record.new(type, record_value)
      end
    end
  end
end
