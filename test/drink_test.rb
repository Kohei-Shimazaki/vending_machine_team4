require "minitest/autorun"
require "./lib/vending_machine"

class DrinkTest < Minitest::Test
  def test_new
    assert Drink.new("サイダー", 120, 5)
  end
end
