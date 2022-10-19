# frozen_string_literal: true

require "spec_helper"

RSpec.describe Taro::Util do
  describe "#unpack_big_size" do
    let(:decode_vector) do
      JSON.parse(File.read(fixture_path("bigsize/decode.json")))
    end

    it do
      decode_vector.each do |data|
        if data["exp_error"]
          expect do
            described_class.unpack_big_size(data["bytes"].htb)
          end.to raise_error(Taro::Error, data["exp_error"])
        else
          expect(described_class.unpack_big_size(data["bytes"].htb)).to eq(
            data["value"]
          )
        end
      end
    end
  end

  describe "#pack_big_size" do
    let(:encode_vector) do
      JSON.parse(File.read(fixture_path("bigsize/encode.json")))
    end

    it do
      encode_vector.each do |data|
        expect(described_class.pack_big_size(data["value"]).bth).to eq(
          data["bytes"]
        )
      end
    end
  end
end
