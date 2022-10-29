# frozen_string_literal: true

require "taro"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do |example|
    Bitcoin.chain_params = (example.metadata[:network] || :testnet)
  end
end

def fixture_path(relative_path)
  File.join(File.dirname(__FILE__), "fixtures", relative_path)
end

def genesis_sample
  genesis_point =
    Bitcoin::OutPoint.from_txid(
      "af2ed8bc93a28cba80bc3c8c55fc554bb7cb3f9071f59f87b83724d4e8b92ea9",
      1
    )
  Taro::Genesis.new(
    prev_out: genesis_point,
    tag: "testcoin",
    metadata: "metadata for test",
    output_index: 0
  )
end

def asset_sample
  script_key =
    Bitcoin::Key.new(
      pubkey:
        "026e552eef52663dcf984ad1443660a66923aca4c8b77240fb83114dbb0ea91269"
    )
  Taro::Asset.new(genesis_sample, 1_000, 0, 0, script_key)
end
