class Drink
  attr_reader :name, :price, :stock

  def initialize(name, price, stock)
    @name = name
    @price = price
    @stock = stock
  end

  def sell
    @stock -= 1
  end

  def restock(restock)
    @stock += restock
  end
end

class VendingMachine
  attr_reader :slot_money, :earnings, :products
  MONEY = [10, 50, 100, 500, 1000].freeze

  def init_products
    @products = []
    @products.push(Drink.new("コーラ", 120, 5))
    @products.push(Drink.new("レッドブル", 200, 5))
    @products.push(Drink.new("水", 100, 5))
  end

  def restock(name, stock)
    if drink = @products.find{|product| product.name == name}
      drink.restock(stock)
    else
      puts "#{name}の値段はいくらですか？"
      price = gets.chomp!.to_i
      @products.push(Drink.new(name, price, stock))
    end
  end

  def initialize
    @slot_money = 0
    @earnings = 0
    @products = init_products
  end

  def slot(money)
    MONEY.include?(money) ? @slot_money += money : puts(money)
    able_to_sell_lists
  end

  def return_money
    puts "返却：#{@slot_money}円"
    @slot_money = 0
  end

  def able_to_sell_lists
    @able_to_sell_lists = []
    @products.each do |product|
      if @slot_money >= product.price && product.stock > 0
        @able_to_sell_lists.push(product)
      end
    end
    @able_to_sell_lists.each{|product| puts "#{product.name}は購入可能です"}
  end

  def sell(name)
    if choose = @able_to_sell_lists.find{|product| product.name == name}
      @earnings += choose.price
      @slot_money -= choose.price
      choose.sell
      puts "購入：#{choose.name}, 釣り銭：#{@slot_money}円"
    end
  end
end

#vm = VendingMachine.new
#vm.slot(100)
#vm.slot(10)
#vm.slot(10)
#p vm.able_to_sell_lists
#vm.sell("サイダー")
#vm.sell("コーラ")
#p vm.products
#vm.return_money
