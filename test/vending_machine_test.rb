require "minitest/autorun"
require "./lib/vending_machine"

class VendingMachineTest < Minitest::Test
  def test_new
    assert VendingMachine.new
  end

  def test_slot_true
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
  def test_slot_false
    vm = VendingMachine.new
    assert_output("5\n") {vm.slot(5)}
  end

  def test_able_to_sell_lists_true
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
  def test_able_to_sell_lists_false
    vm = VendingMachine.new
    vm.slot(50)
    assert_nil vm.able_to_sell_lists.find{|product| product.name == "水"}
    vm.slot(50)
    assert_nil vm.able_to_sell_lists.find{|product| product.name == "コーラ"}
    vm.slot(50)
    assert_nil vm.able_to_sell_lists.find{|product| product.name == "レッドブル"}
  end

  def test_return_money
    vm = VendingMachine.new
    assert_output("返却：0円\n") {vm.return_money}
    vm.slot(100)
    vm.slot(10)
    assert_output("返却：110円\n") {vm.return_money}
    vm.slot(100)
    vm.slot(50)
    assert_output("返却：150円\n") {vm.return_money}
  end

  def test_sell_true
    vm = VendingMachine.new
    vm.slot(100)
    vm.slot(10)
    vm.slot(10)
    assert_output("購入：コーラ, 釣り銭：0円\n") {vm.sell("コーラ")}
    assert_equal 120, vm.earnings
    assert_equal 4, vm.products.find{|product| product.name == "コーラ"}.stock
  end
  def test_sell_false
    vm = VendingMachine.new
    vm.slot(100)
    assert_nil vm.sell("コーラ")
    assert_nil vm.sell("サイダー")
  end

  def restock
    vm = VendingMachine.new
    vm.restock("コーラ", 5)
    assert_equal 10, vm.products.find{|product| product.name == "コーラ"}.stock
    vm.restock("サイダー", 5)
    assert_equal 5, vm.products.find{|product| product.name == "サイダー"}.stock
  end
end
