require 'vending_machine'

describe VendingMachine do
  let(:vm) { VendingMachine.new }

  describe "自動販売機初期化" do
    it "売上が0円である" do
      expect(vm.earnings).to eq(0)
    end
    it "投入金が0円である" do
      expect(vm.slot_money).to eq(0)
    end
    context "コーラが格納されている" do
      it "商品名はコーラである" do
        expect(vm.products[0].name).to eq("コーラ")
      end
      it "値段は120円である" do
        expect(vm.products[0].price).to eq(120)
      end
      it "在庫は5本である" do
        expect(vm.products[0].stock).to eq(5)
      end
    end
    context "レッドブルが格納されている" do
      it "商品名はレッドブルである" do
        expect(vm.products[1].name).to eq("レッドブル")
      end
      it "値段は200円である" do
        expect(vm.products[1].price).to eq(200)
      end
      it "在庫は5本である" do
        expect(vm.products[1].stock).to eq(5)
      end
    end
    context "水が格納されている" do
      it "商品名は水である" do
        expect(vm.products[2].name).to eq("水")
      end
      it "値段は100円である" do
        expect(vm.products[2].price).to eq(100)
      end
      it "在庫は5本である" do
        expect(vm.products[2].stock).to eq(5)
      end
    end
  end

  describe "お金を投入" do
    context "定数MONEYではないお金が投入された場合" do
      it "投入金は変化しない" do
        vm.slot(5)
        expect(vm.slot_money).to eq(0)
      end
      it "投入されたお金がそのまま標準出力される" do
        expect{ vm.slot("1000円札") }.to output("1000円札\n").to_stdout
      end
    end
    context "定数MONEYに含まれるお金が投入された場合" do
      it "投入金が加算される" do
        vm.slot(10)
        vm.slot(50)
        vm.slot(100)
        vm.slot(500)
        expect(vm.slot_money).to eq(660)
      end
      context "投入金が商品の値段以下の場合" do
        it "購入可能リストは空である" do
          vm.slot(50)
          expect(vm.able_to_sell_lists).to eq([])
        end
      end
      context "投入金が商品の値段以上の場合" do
        it "購入可能リストに商品が追加される" do
          vm.slot(100)
          expect(vm.able_to_sell_lists[0].name).to eq("水")
        end
        it "購入可能リストが標準出力される" do
          expect{ vm.slot(100) }.to output("水は購入可能です\n").to_stdout
        end
      end
    end
  end

  describe "商品を購入" do
    context "投入金が商品の値段よりも低い場合" do
      it "商品を購入できない" do
        vm.slot(50)
        expect(vm.sell("水")).to be_nil
      end
    end
    context "投入金が商品の値段よりも高い、かつ在庫がある場合" do
      it "売上を商品の値段分、加算する" do
        vm.slot(500)
        vm.sell("水")
        vm.sell("コーラ")
        vm.sell("レッドブル")
        expect(vm.earnings).to eq(420)
      end
      it "投入金を商品の値段分、減算する" do
        vm.slot(500)
        vm.sell("コーラ")
        expect(vm.slot_money).to eq(380)
      end
      it "購入された商品の在庫を1つ減らす" do
        vm.slot(500)
        vm.sell("コーラ")
        expect(vm.products[0].stock).to eq(4)
      end
      it "購入時に、購入した商品名、残金を表示する" do
        vm.slot(100)
        expect{ vm.sell("水") }.to output("購入：水, 残金：0円\n").to_stdout
      end
      it "購入後に、残金で購入可能な商品を表示する" do
        vm.slot(500)
        expect{ vm.sell("水") }.to output("購入：水, 残金：400円\nコーラは購入可能です\nレッドブルは購入可能です\n水は購入可能です\n").to_stdout
      end
    end
    context "在庫がない場合" do
      it "商品を購入できない" do
        vm.slot(1000)
        5.times do
          vm.sell("コーラ")
        end
        expect(vm.sell("コーラ")).to be_nil
      end
    end
  end

  describe "商品を補充" do
    context "投入金が自動販売機に残っている場合" do
      it "注意文が標準出力される" do
        vm.slot(100)
        expect{ vm.restock("コーラ", 5) }.to output("投入金を回収してからやり直してください\n").to_stdout
      end
      it "商品は補充されない" do
        vm.slot(100)
        expect(vm.restock("コーラ", 5)).to be_nil
      end
    end
    context "投入金がない場合" do
      it "商品が補充できる" do
        vm.restock("コーラ", 5)
        expect(vm.products[0].stock).to eq(10)
      end
      it "自販機にない商品も補充できる(値段を入力する必要あり)" do
        vm.restock("サイダー", 5)
        expect(vm.products[3].name).to eq("サイダー")
      end
    end
  end

  describe "投入金を返却" do
    it "投入金を標準出力する" do
      vm.slot(500)
      expect{ vm.return_money }.to output("返却：500円\n").to_stdout
    end
    it "投入金を0円に戻す" do
      vm.slot(500)
      vm.return_money
      expect(vm.slot_money).to eq(0)
    end
  end
end
