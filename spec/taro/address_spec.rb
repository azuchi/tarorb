# frozen_string_literal: true

require "spec_helper"

RSpec.describe Taro::Address do
  describe "#decode" do
    subject(:address) { described_class.decode(addr) }

    let(:addr) do
      "tarotb1qqqsqqjy4yhtn6x5ysmm3pul74ceq07tka94tlz43s7teq963j3f80xc96hsqqqqqyy8getnw33k76twz9kk2arpv3shgcfqvehhygr5v4ehgqqqqqqqqppq5746x7psp9fvl0mhs6f80zcnpzlch5v97xh46j6459sy80supf9svgzkf72uhhmf2a2ma8s8glra7dqagk96n47fda64q6dkmu32xjfw7syq8lgp7syf8tft"
    end

    it do
      expect(address.version).to eq(0)
      expect(address.asset_id).to eq(
        "9333d8360be674dfae320b7ae16bd3b618726637fad107a1d2b248a3083061ca"
      )
      expect(address.amount).to eq(500)
      expect(address.script_key.pubkey).to eq(
        "02a7aba378300952cfbf778692778b1308bf8bd185f1af5d4b55a16043be1c0a4b"
      )
      expect(address.internal_key.pubkey).to eq(
        "02564f95cbdf695755be9e0747c7df341d458ba9d7c96f755069b6df22a3492ef4"
      )
      expect(address.taproot_output_key).to eq(
        "37fc965befde457f4c7943750d83a5743a565fb12eaf7c01c3084fe8b106f533"
      )
      expect(address.encode).to eq(addr)
    end
  end
end
