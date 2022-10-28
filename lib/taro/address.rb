# frozen_string_literal: true

require "bech32"

module Taro
  # Taro address
  class Address
    HRP_MAINNET = "tarobc"
    HRP_TESTNET = "tarotb"
    HRP_REGTEST = "tarort"

    attr_accessor :version,
                  :genesis,
                  :family_key,
                  :script_key,
                  :internal_key,
                  :amount,
                  :asset_type

    # Constructor
    # @param [Integer] version
    # @param [Taro::Genesis] genesis
    # @param [Bitcoin::Key] script_key
    # @param [Integer] amount
    # @param [Bitcoin::Key] internal_key
    # @param [Bitcoin::Key] family_key optional
    # @param [Integer] asset_type optional
    def initialize(
      version:,
      genesis:,
      script_key:,
      internal_key:,
      amount:,
      family_key: nil,
      asset_type: nil
    )
      @version = version
      @genesis = genesis
      @script_key = script_key
      @amount = amount
      @internal_key = internal_key
      @family_key = family_key
      @asset_type = asset_type
    end

    # Encode taro address as bech32m.
    # @return [String] taro address
    def encode
      payload = tlv_records.map { |r| TLV::AddressEncoder.encode(r) }.join
      data = Bech32.convert_bits(payload.unpack("C*"), 8, 5)
      Bech32.encode(Address.hrp, data, Bech32::Encoding::BECH32M)
    end

    # Get asset id.
    # @return [String] asset id with hex format.
    def asset_id
      genesis.id
    end

    # Decode bech32m taro address
    # @param [String] bech32m taro address
    # @return [Taro::Address]
    # @raise [Taro::Error]
    def self.decode(bech32m)
      hrp, data, = Bech32.decode(bech32m, bech32m.length)
      raise Taro::Error, "HRP: #{hrp} is invalid hrp" unless hrp == Address.hrp

      converted = Bech32.convert_bits(data, 5, 8, false)
      buf = StringIO.new(converted.pack("C*"))
      records = {}
      until buf.eof?
        record = TLV::AddressDecoder.decode(buf)
        records[record.type] = record.value
      end
      Address.new(
        version: records[TLV::AddrType::VERSION],
        genesis: records[TLV::AddrType::ASSET_GENESIS],
        script_key: records[TLV::AddrType::SCRIPT_KEY],
        internal_key: records[TLV::AddrType::INTERNAL_KEY],
        amount: records[TLV::AddrType::AMOUNT],
        family_key: records[TLV::AddrType::FAM_KEY]
      )
    end

    # Return the HRP corresponding to the current chain parameters.
    # @return [String] HRP
    def self.hrp
      Bitcoin.chain_params.mainnet? ? HRP_MAINNET : HRP_TESTNET
    end

    # Return TLV records.
    # @return [Array]
    def tlv_records
      records = [
        TLV::Record.new(TLV::AddrType::VERSION, version),
        TLV::Record.new(TLV::AddrType::ASSET_GENESIS, genesis),
        TLV::Record.new(TLV::AddrType::SCRIPT_KEY, script_key),
        TLV::Record.new(TLV::AddrType::INTERNAL_KEY, internal_key),
        TLV::Record.new(TLV::AddrType::AMOUNT, amount)
      ]
      if family_key
        records << TLV::Record.new(TLV::AddrType::FAM_KEY, family_key)
      end
      records << TLV::Record.new(TLV::AddrType::ASSET_TYPE, type) if asset_type # TODO
      records
    end
  end
end
