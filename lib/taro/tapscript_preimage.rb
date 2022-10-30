# frozen_string_literal: true
module Taro
  # Denotes the type of tapscript sibling preimage.
  class TapscriptPreimage
    TYPE_LEAF = 0
    TYPE_BRANCH = 1

    attr_reader :sibling_preimage, :sibling_type

    # Constructor
    # @param [String] sibling_preimage
    # @param [Integer] sibling_type
    # @raise [Error]
    def initialize(sibling_type, sibling_preimage)
      unless [TYPE_LEAF, TYPE_BRANCH].include?(sibling_type)
        raise Taro::Error, "Sibling type: #{sibling_type} does not supported"
      end

      @sibling_preimage = sibling_preimage
      @sibling_type = sibling_type
    end
  end
end
