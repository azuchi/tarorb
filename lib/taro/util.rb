# frozen_string_literal: true

module Taro
  # Utility module
  module Util
    module_function

    # Read a variable length integer as BigSize
    # @return [Integer]
    # @raise [Taro::Error] If not canonical
    def unpack_big_size(data)
      buf = data.is_a?(StringIO) ? data : StringIO.new(data)
      v = buf.read(1)&.unpack1("C")
      case v
      when 0xfd
        data = buf.read(2)&.unpack1("n")
        raise Error, "unexpected EOF" unless data
        raise Error, "decoded bigsize is not canonical" if data < 0xfd
        data
      when 0xfe
        data = buf.read(4)&.unpack1("N")
        raise Error, "unexpected EOF" unless data
        raise Error, "decoded bigsize is not canonical" if data <= 0xffff
        data
      when 0xff
        data = buf.read(8)&.unpack1("Q>")
        raise Error, "unexpected EOF" unless data
        raise Error, "decoded bigsize is not canonical" if data <= 0xffffffff
        data
      else
        raise Error, "EOF" unless v
        v
      end
    end

    # Unpack +data+.
    # @param [String|StringIO] data
    # @return [String] unpacked data.
    def unpack_var_string(data)
      buf = data.is_a?(StringIO) ? data : StringIO.new(data)
      len = unpack_big_size(buf)
      buf.read(len)
    end

    # Serialize +value+ as a variable number of bytes.
    # @param [Integer] value value to be serialized.
    # @return [String] big size value.
    # @raise [Taro::Error] if +value+ is too large.
    def pack_big_size(value)
      if value < 0xfd
        [value].pack("C")
      elsif value <= 0xffff
        [0xfd, value].pack("Cn")
      elsif value <= 0xffffffff
        [0xfe, value].pack("CN")
      elsif value <= 0xffffffffffffffff
        [0xff, value].pack("CQ>")
      else
        raise Error, "#{value} is too large!"
      end
    end

    # Convert +value+ to pack_big_size(+value+.bytesize) + value
    # @return [String]
    def pack_var_string(value)
      pack_big_size(value.bytesize) + value
    end

    # Returns the length in bytes that a packed bit vector would consume.
    # @param [Integer] bits
    # @return [Integer] length in bytes.
    def packed_bits_len(bits)
      ((bits + 8 - 1) / 8.0).ceil
    end

    # Unpack a byte slice into a bit vector.
    # @param [String] bytes byte slice
    # @return [Array] bit vector
    def unpack_bits(bytes)
      bits = Array(bytes * 8)
      bits.length.times do |i|
        byte_index = i / 8
        byte_value = bytes[byte_index]
        bit_index = i % 8
        bits[i] = ((byte_value >> bit_index) & 1) == 1
      end
      bits
    end
  end
end
