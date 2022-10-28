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
            data = []
            data << AssetLeafDecoder.decode(buf) until buf.eof?
            data
          when ProofType::INCLUSION_PROOF
            buf = StringIO.new(value)
            data = []
            data << TaprootProofDecoder.decode(buf) until buf.eof?
            data
          else
            raise Taro::Error, "Unsupported type: #{type} found in proof tlv"
          end
        Record.new(type, record_value)
      end
    end
  end
end
