class Drink
  attr_reader :name, :price
  attr_accessor :stock

  def initialize(name, price, stock)
    @name = name
    @price = price
    @stock = stock
  end
end

class VendingMachine
  attr_reader :slot_money, :earnings, :products
  MONEY = [10, 50, 100, 500, 1000].freeze

  def initialize
    @slot_money = 0
    @earnings = 0
    @products = []
    @products.push(Drink.new("コーラ", 120, 5))
    @products.push(Drink.new("レッドブル", 200, 5))
    @products.push(Drink.new("水", 100, 5))
  end

  # 商品を補充するメソッド
  def restock(name, stock)
    if @slot_money == 0
      if drink = @products.find{|product| product.name == name}
        drink.stock += stock
      else
        puts "#{name}の値段はいくらですか？"
        price = gets.chomp!.to_i
        @products.push(Drink.new(name, price, stock))
      end
    else
      puts '投入金を回収してからやり直してください'
    end
  end

  # 投入金を入れるメソッド
  def slot(money)
    MONEY.include?(money) ? @slot_money += money : puts(money)
    able_to_sell_lists
  end

  # 投入金を返却するレバーのイメージ
  def return_money
    puts "返却：#{@slot_money}円"
    @slot_money = 0
  end

  # 商品ボタンが光るイメージ
  def able_to_sell_lists
    @able_to_sell_lists = []
    @products.each do |product|
      if @slot_money >= product.price && product.stock > 0
        @able_to_sell_lists.push(product)
      end
    end
    @able_to_sell_lists.each{|product| puts "#{product.name}は購入可能です"}
  end

  # 商品を売るメソッド
  def sell(name)
    if (choose = @able_to_sell_lists.find{|product| product.name == name})
      @earnings += choose.price
      @slot_money -= choose.price
      choose.stock -= 1 #在庫を1減らす
      puts "購入：#{choose.name}, 残金：#{@slot_money}円"
      able_to_sell_lists
    end
  end
end
