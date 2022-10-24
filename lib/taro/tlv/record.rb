# frozen_string_literal: true

module Taro
  module TLV
    # Taro TLV record
    class Record
      include Taro::Util
      attr_reader :type, :value

      # Constructor
      # @param [Integer] type TLV type.
      # @param [Object] value TLV value.
      def initialize(type, value)
        raise ArgumentError, "type must be integer" unless type.is_a?(Integer)
        if type < Taro::TLV::VERSION || Taro::TLV::ASSET_FAMILY_KEY < type
          raise ArgumentError, "unsupported type specified"
        end

        @type = type
        @value = value
      end
    end
  end
end
