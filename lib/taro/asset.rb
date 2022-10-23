# frozen_string_literal: true

module Taro
  # Genesis encodes an asset's genesis metadata
  class Genesis
    include Bitcoin::Util
    include Taro::Util

    attr_reader :first_prev_out, :tag, :metadata, :output_index, :type

    # Constructor
    # @param [Bitcoin::OutPoint] prev_out
    # @param [String] tag
    # @param [String] metadata
    # @param [Integer] output_index
    # @param [Integer] type
    # @return ArgumentError
    def initialize(
      prev_out:,
      tag:,
      metadata:,
      output_index:,
      type: Asset::TYPE_NORMAL
    )
      unless prev_out.is_a?(Bitcoin::OutPoint)
        raise "prev_out should be Bitcoin::OutPoint instance"
      end

      @first_prev_out = prev_out
      @tag = tag
      @metadata = metadata
      @output_index = output_index
      @type = type
    end

    def tag_hash
      Bitcoin.sha256(tag)
    end

    def metadata_hash
      Bitcoin.sha256(metadata)
    end

    # Calculate asset id.
    # @return [String] asset id with hex format.
    def id
      payload =
        first_prev_out.to_payload + tag_hash + metadata_hash +
          [output_index, type].pack("I>C")
      Bitcoin.sha256(payload).bth
    end

    # Encode genesis
    # @return [String] encoded genesis
    def encode
      first_prev_out.tx_hash.htb + [first_prev_out.index].pack("N") +
        pack_var_string(tag) + pack_var_string(metadata) +
        [output_index, type].pack("I>C")
    end
  end

  # Asset represents a Taro asset.
  class Asset
    TYPE_NORMAL = 0
    TYPE_COLLECTIBLE = 1

    attr_reader :version,
                :genesis,
                :amount,
                :locktime,
                :relative_locktime,
                :prev_witnesses,
                :split_commitment_root,
                :script_version,
                :script_key,
                :family_key

    # @param [Taro::Genesis] genesis
    # @param [Integer] amount
    # @param [Integer] locktime
    # @param [Integer] relative_locktime
    # @param [Bitcoin::Key] script_key
    # @param [Taro::FamilyKey] family_key
    def initialize(
      genesis,
      amount,
      locktime,
      relative_locktime,
      script_key,
      family_key = nil
    )
      @genesis = genesis
      @amount = amount
      @locktime = locktime
      @relative_locktime = relative_locktime
      @script_key = script_key
      @family_key = family_key
      @version = 0
      @prev_witnesses = [Taro::Witness.new(Taro::PrevID.empty)]
      @script_version = 0
    end

    # Calculate asset commitment key that maps to a specific owner of an asset within a Taro AssetCommitment.
    # @return [String] commitment key
    def commitment_key
      payload =
        (
          if family_key.nil?
            script_key.xonly_pubkey.htb
          else
            genesis.id.htb + script_key.xonly_pubkey.htb
          end
        )
      Bitcoin.sha256(payload)
    end

    # Return asset leaf as a MS-SMT leaf node.
    # @return [MSSMT::LeafNode]
    def leaf
      MSSMT::LeafNode.new(tlv, amount)
    end

    private

    def tlv
      tlv_records.map(&:tlv).join
    end

    def tlv_records
      records = [
        TLV::Record.new(TLV::VERSION, version),
        TLV::Record.new(TLV::GENESIS, genesis),
        TLV::Record.new(TLV::ASSET_TYPE, genesis.type),
        TLV::Record.new(TLV::AMOUNT, amount)
      ]
      records << TLV::Record.new(TLV::LOCKTIME, locktime) if locktime.positive?
      if relative_locktime.positive?
        records << TLV::Record.new(TLV::RELATIVE_LOCKTIME, relative_locktime)
      end
      if prev_witnesses.length.positive?
        records << TLV::Record.new(TLV::PREV_ASSET_WITNESS, prev_witnesses)
      end
      if split_commitment_root
        # TODO
      end
      records << TLV::Record.new(TLV::ASSET_SCRIPT_VERSION, script_version)
      records << TLV::Record.new(TLV::ASSET_SCRIPT_KEY, script_key)
      if family_key
        records << TLV::Record.new(TLV::ASSET_FAMILY_KEY, family_key)
      end
      records
    end
  end
end
