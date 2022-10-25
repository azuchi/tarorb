# frozen_string_literal: true

module Taro
  # Proof file comprised of proofs for all of an asset's state transitions back to its genesis state.
  class File
    extend Taro::Util
    include Taro::Util

    # Maximum file size in bytes allowed for a proof file.
    MAX_SIZE = 1 << 32 - 1

    attr_reader :version, :proofs

    # Constructor
    # @param [Integer] version
    # @param [Array] proofs
    def initialize(version, proofs = [])
      @version = version
      @proofs = proofs
    end

    # Decode proof file content.
    # @param [String] payload proof file content.
    # @return [Taro::File]
    def self.decode(payload)
      buf = StringIO.new(payload)
      checksum = buf.read(32)
      content = buf.read
      unless checksum == Bitcoin.sha256(content)
        raise Taro::Error, "Proof file checksum invalid"
      end

      buf = StringIO.new(content)
      version = buf.read(4).unpack1("N")
      num_proofs = unpack_big_size(buf)
      proofs = []
      num_proofs.times do
        proof_len = unpack_big_size(buf)
        raw_proof = StringIO.new(buf.read(proof_len))
        proofs << TLV::ProofDecoder.decode(raw_proof) until raw_proof.eof?
      end
      File.new(version, proofs)
    end
  end
end
