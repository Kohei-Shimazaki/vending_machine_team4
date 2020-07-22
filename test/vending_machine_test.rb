require "minitest/autorun"
require "./lib/vending_machine"

class VendingMachineTest < Minitest::Test
  def test_should_create_new_instance
    assert VendingMachine.new
  end

  def test_should_slot_money
    vm = VendingMachine.new
    vm.slot(10)
    assert_equal 10, vm.slot_money
    vm.slot(50)
    assert_equal 60, vm.slot_money
    vm.slot(100)
    assert_equal 160, vm.slot_money
    vm.slot(500)
    assert_equal 660, vm.slot_money
    vm.slot(1000)
    assert_equal 1660, vm.slot_money
  end
  def test_should_not_slot_everything_except_money
    vm = VendingMachine.new
    assert_output("5\n") {vm.slot(5)}
  end

  def test_should_be_available_with_valid_drink_list
    vm = VendingMachine.new
    vm.slot(100)
    assert vm.able_to_sell_lists.find{|product| product.name == "水"}
    vm.slot(10)
    vm.slot(10)
    assert vm.able_to_sell_lists.find{|product| product.name == "コーラ"}
    assert vm.able_to_sell_lists.find{|product| product.name == "水"}
    vm.slot(100)
    assert vm.able_to_sell_lists.find{|product| product.name == "コーラ"}
    assert vm.able_to_sell_lists.find{|product| product.name == "レッドブル"}
    assert vm.able_to_sell_lists.find{|product| product.name == "水"}
  end
  def test_should_not_be_available_with_invalid_drink_list
    vm = VendingMachine.new
    vm.slot(50)
    assert_nil vm.able_to_sell_lists.find{|product| product.name == "水"}
    vm.slot(50)
    assert_nil vm.able_to_sell_lists.find{|product| product.name == "コーラ"}
    vm.slot(50)
    assert_nil vm.able_to_sell_lists.find{|product| product.name == "レッドブル"}
  end

  def test_should_return_money
    vm = VendingMachine.new
    assert_output("返却：0円\n") {vm.return_money}
    vm.slot(100)
    vm.slot(10)
    assert_output("返却：110円\n") {vm.return_money}
    vm.slot(100)
    vm.slot(50)
    assert_output("返却：150円\n") {vm.return_money}
  end

  def test_should_sell_products
    vm = VendingMachine.new
    vm.slot(100)
    vm.slot(10)
    vm.slot(10)
    assert_output("購入：コーラ, 釣り銭：0円\n") {vm.sell("コーラ")}
    assert_equal 120, vm.earnings
    assert_equal 4, vm.products.find{|product| product.name == "コーラ"}.stock
  end
  def test_should_not_sell_products_when_slot_money_is_less_than_price
    vm = VendingMachine.new
    vm.slot(100)
    assert_nil vm.sell("コーラ")
    assert_nil vm.sell("サイダー")
  end
  def test_should_not_sell_products_when_products_are_out_of_stock
    vm = VendingMachine.new
    vm.slot(1000)
    5.times do
      vm.sell("コーラ")
    end
    assert_nil vm.sell("コーラ")
  end

  def should_restock_products
    vm = VendingMachine.new
    vm.restock("コーラ", 5)
    assert_equal 10, vm.products.find{|product| product.name == "コーラ"}.stock
    vm.restock("サイダー", 5)
    assert_equal 5, vm.products.find{|product| product.name == "サイダー"}.stock
  end

  def should_not_restock_products_when_slot_money_is_not_zero
    vm = VendingMachine.new
    vm.slot(100)
    assert_output("投入金を回収してからやり直してください\n") {vm.restock("コーラ", 5)}
  end
end
