namespace :opensearch do
  desc "OpenSearchの products インデックスを作成し、既存の商品データを全件流し込む"
  task setup: :environment do
    OpensearchClient.ensure_index!

    Product.find_each do |product|
      OpensearchClient.index_product(product)
      print "."
    end

    puts "\nOpenSearchへ#{Product.count}件の商品をインデックスしました"
  end
end
