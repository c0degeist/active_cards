module RandomizedTestHelpers

  def disable_randomized_tests
    stub_const('Test::RANDOMIZED', false)
  end

  def enable_randomized_tests
    stub_const('Test::RANDOMIZED', true)
  end

end

RSpec.configure do |config|
  config.include(RandomizedTestHelpers)
end
