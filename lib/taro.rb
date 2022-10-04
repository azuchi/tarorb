# frozen_string_literal: true

require 'bitcoin'
require_relative 'taro/version'

# Taro library for issuing assets on the Bitcoin blockchain.
module Taro
  class Error < StandardError
  end
  autoload :Asset, 'taro/asset'
end
