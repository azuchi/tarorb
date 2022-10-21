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
  end
end
