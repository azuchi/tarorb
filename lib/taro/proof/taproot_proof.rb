module Taro
  class TaprootProof
    attr_reader :output_index,
                :internal_key,
                :commitment_proof,
                :tapscript_proof
    def self.decode(data)
      buf = data.is_a?(StringIO) ? data : StringIO.new(data)
      num = unpack_big_size(buf)
      hashes = num.times.map { buf.read(32) }
      bits = buf.read(packed_bits_len(num))
    end
  end
end
