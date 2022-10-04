module Taro
  class Genesis
    attr_reader :first_prev_out
    attr_reader :tag
    attr_reader :metadata
    attr_reader :output_index
    attr_reader :type

    # Constructor
    # @param [Bitcoin::OutPoint] prev_out
    # @param [String] tag
    # @param [String] metadata
    # @param [Integer] output_index
    # @param [Integer] type
    # @return ArgumentError
    def initialize(prev_out:, tag:, metadata:, output_index:, type: Asset::TYPE_NORMAL)
      raise "prev_out should be Bitcoin::OutPoint instance" unless prev_out.is_a?(Bitcoin::OutPoint)
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
      payload = first_prev_out.to_payload + tag_hash + metadata_hash + [output_index, type].pack('VC')
      Bitcoin.sha256(payload).bth
    end
  end

  class Asset

    TYPE_NORMAL = 0
    TYPE_COLLECTIBLE = 1

    attr_reader :ver
    attr_reader :genesis
    attr_reader :amount
    attr_reader :locktime
    attr_reader :relative_locktime
    attr_reader :prev_witnesses
    attr_reader :split_commitment_root
    attr_reader :script_ver
    attr_reader :script_key
    attr_reader :family_key
  end
end