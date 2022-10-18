# frozen_string_literal: true

module Taro
  # Genesis encodes an asset's genesis metadata
  class Genesis
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
  end

  # Asset represents a Taro asset.
  class Asset
    TYPE_NORMAL = 0
    TYPE_COLLECTIBLE = 1

    attr_reader :ver,
                :genesis,
                :amount,
                :locktime,
                :relative_locktime,
                :prev_witnesses,
                :split_commitment_root,
                :script_ver,
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
  end
end
