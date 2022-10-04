# frozen_string_literal: true
require 'bitcoin'
require_relative "taro/version"

module Taro
  class Error < StandardError; end
  autoload :Asset, 'taro/asset'
end
