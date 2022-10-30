# frozen_string_literal: true

module Taro
  module TLV
    # Decoder for taproot proof TLV data.
    module TaprootProofDecoder
      extend Taro::Util

      module_function

      # Decode TLV data to record.
      # @param [String] data TaprootProof TLV data.
      # @return [Taro::TLV::Record]
      def decode(data)
        buf = data.is_a?(StringIO) ? data : StringIO.new(data)
        type = unpack_big_size(buf)
        value = unpack_var_string(buf)
        record_value =
          case type
          when TaprootProofType::OUTPUT_INDEX
            value.unpack1("N")
          when TaprootProofType::INTERNAL_KEY
            Bitcoin::Key.from_xonly_pubkey(value.bth)
          when TaprootProofType::COMMITMENT_PROOF
            buf = StringIO.new(value)
            records = {}
            until buf.eof?
              record = CommitmentProofDecoder.decode(buf)
              records[record.type] = record.value
            end
            CommitmentProof.new(
              asset_proof: records[CommitmentProofType::ASSET_PROOF],
              taro_proof: records[CommitmentProofType::TARO_PROOF],
              tap_sibling_preimage:
                records[CommitmentProofType::TAP_SIBLING_PREIMAGE]
            )
          when TaprootProofType::TAPSCRIPT_PROOF
            TapscriptProofDecoder.decode(value)
          end
        Record.new(type, record_value)
      end
    end
  end
end
