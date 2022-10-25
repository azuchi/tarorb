# frozen_string_literal: true

module Taro
  # PrevID serves as a reference to an asset's previous input.
  class PrevID
    include Taro::Util
    extend Taro::Util
    attr_reader :out_point, :id, :script_key

    # Constructor
    # @param [Bitcoin::OutPoint] out_point refers to the asset's previous output position within a transaction.
    # @param [String] id Asset ID of the previous asset tree.
    # @param [String] script_key Previously tweaked Taproot output key
    # committing to the possible spending conditions of the asset.
    def initialize(out_point, id, script_key)
      @out_point = out_point
      @id = id
      @script_key = script_key
    end

    def self.empty
      out_point = Bitcoin::OutPoint.from_txid("00" * 32, 0)
      asset_id = ("00" * 32).htb
      script_key = ("00" * 33).htb
      PrevID.new(out_point, asset_id, script_key)
    end

    # Convert as TLV data.
    # @return [String] tlv data.
    def tlv
      buf = pack_big_size(Taro::TLV::WitnessType::PREV_ASSET_ID)
      value =
        out_point.tx_hash.htb + [out_point.index].pack("N") + id +
          script_key[1..]
      buf << pack_var_string(value)
    end

    # Decode tlv value as PrevID
    # @param [String] payload
    # @return [Taro::PrevID]
    def self.decode(payload)
      buf = StringIO.new(payload)
      tx_hash = buf.read(32).bth
      index = buf.read(4).unpack1("N")
      id = buf.read(32)
      script_key = buf.read(32)
      PrevID.new(Bitcoin::OutPoint.new(tx_hash, index), id, script_key)
    end
  end

  # Witness is a nested TLV stream within the main Asset TLV stream that contains the necessary data
  # to verify the movement of an asset. All fields should be nil to represent the creation of an asset,
  # `tx_witness` and `split_commitment_proof` are mutually exclusive otherwise.
  class Witness
    attr_accessor :prev_id, :tx_witness, :split_commitment

    # Constructor
    # @param [Taro::PrevID] prev_id Reference to an asset's previous input.
    # @param [Bitcoin::ScriptWitness] tx_witness
    # @param [Taro::SplitCommitment] split_commitment
    def initialize(prev_id, tx_witness = nil, split_commitment = nil)
      @prev_id = prev_id
      @tx_witness = tx_witness
      @split_commitment = split_commitment
    end
  end
end
