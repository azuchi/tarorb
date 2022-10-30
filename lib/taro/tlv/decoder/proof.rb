# frozen_string_literal: true
module Taro
  module TLV
    # Decoder for Proof TLV data.
    module ProofDecoder
      extend Taro::Util

      module_function

      # Decode TLV data to record.
      # @param [String] data Proof TLV data.
      # @return [Taro::TLV::Record]
      def decode(data)
        buf = data.is_a?(StringIO) ? data : StringIO.new(data)
        type = unpack_big_size(buf)
        value = unpack_var_string(buf)
        record_value =
          case type
          when ProofType::PREV_OUT
            Bitcoin::OutPoint.new(value[0...32], value[32..-1].unpack1("N"))
          when ProofType::BLOCK_HEADER
            Bitcoin::BlockHeader.parse_from_payload(value)
          when ProofType::ANCHOR_TX
            Bitcoin::Tx.parse_from_payload(value)
          when ProofType::MERKLE_PROOF
            TxMerkleProof.decode(value)
          when ProofType::ASSET_LEAF
            buf = StringIO.new(value)
            records = {}
            until buf.eof?
              record = AssetLeafDecoder.decode(buf)
              records[record.type] = record.value
            end
            Asset.new(
              records[TLV::GENESIS],
              records[TLV::AMOUNT],
              records[TLV::LOCKTIME],
              records[TLV::RELATIVE_LOCKTIME],
              records[TLV::ASSET_SCRIPT_KEY],
              records[TLV::ASSET_FAMILY_KEY]
            )
          when ProofType::INCLUSION_PROOF
            buf = StringIO.new(value)
            records = {}
            until buf.eof?
              record = TaprootProofDecoder.decode(buf)
              records[record.type] = record.value
            end
            TaprootProof.new(
              output_index: records[TaprootProofType::OUTPUT_INDEX],
              internal_key: records[TaprootProofType::INTERNAL_KEY],
              commitment_proof: records[TaprootProofType::COMMITMENT_PROOF],
              tapscript_proof: records[TaprootProofType::TAPSCRIPT_PROOF]
            )
          else
            raise Taro::Error, "Unsupported type: #{type} found in proof tlv"
          end
        Record.new(type, record_value)
      end
    end
  end
end
