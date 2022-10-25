module Taro
  class TxMerkleProof
    include Taro::Util
    extend Taro::Util

    attr_reader :hashes, :bits

    def initialize(hashes, bits)
      @hashes = hashes
      @bits = bits
    end

    # Decode +data+ as TxMerkleProof.
    # @return [String] data
    # @return [Taro::TxMerkleProof]
    def self.decode(data)
      buf = data.is_a?(StringIO) ? data : StringIO.new(data)
      num = unpack_big_size(buf)
      hashes = num.times.map { buf.read(32) }
      bits = buf.read(packed_bits_len(num))

      TxMerkleProof.new(hashes, bits[0..num])
    end
  end
end
