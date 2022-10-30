# frozen_string_literal: true

module Taro
  module TLV
    # Decoder for commitment proof TLV data.
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
            records = {}
            until buf.eof?
              record = AssetProofDecoder.decode(buf)
              records[record.type] = record.value
            end
            AssetProof.new(
              proof: records[AssetProofType::PROOF],
              version: records[AssetProofType::VERSION],
              asset_id: records[AssetProofType::ASSET_ID]
            )
          when CommitmentProofType::TARO_PROOF
            buf = StringIO.new(value)
            records = {}
            until buf.eof?
              record = TaroProofDecoder.decode(buf)
              records[record.type] = record.value
            end
            TaroProof.new(
              proof: records[TaroProofType::PROOF],
              version: records[TaroProofType::VERSION]
            )
          when CommitmentProofType::TAP_SIBLING_PREIMAGE
            sibling_type, preimage = value.unpack("Ca*")
            TapscriptPreimage.new(sibling_type, preimage)
          else
            raise Taro::Error, "Unsupported type: #{type}"
          end
        Record.new(type, record_value)
      end
    end
  end
end
