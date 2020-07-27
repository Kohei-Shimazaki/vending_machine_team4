# VendingMachine

### 使用方法

#### 自動販売機初期化

````
$ irb
> require './lib/vending_machine'
> machine = VendingMachine.new
````

#### 商品補充

````
> machine.restock "コーラ または レッドブル または 水", 補充したい本数(整数)
> machine.restock "上の3つ以外のドリンク", 補充したい本数(整数)
> ○○の値段はいくらですか？ と聞かれるので、値段を入力
# 投入金が0でないときに、restockメソッドを使うと、
# '投入金を回収してからやり直してください'と注意書きが出ます。
# その場合、return_moneyメソッドを使って投入金を0にしてください。
````

#### お金を投入

````
> machine.slot(10 または 50 または 100 または 500 または 1000)
> machine.slot(上以外の整数、あるいは文字列)　# 標準出力され、投入金は変化しない
````

#### 商品を購入

````
> machine.sell("購入したい商品名")
````

#### 投入金を返却

````
> machine.return_money
````

### テスト方法

````
# RSpec
$ bundle install
$ rspec

# Minitest
$ ruby test/vending_machine_test.rb
$ ruby test/drink_test.rb
````
