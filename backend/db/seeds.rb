# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# --- Users ---
users = [
  { clerk_user_id: "user_001", email: "alice@example.com", point_balance: 500 },
  { clerk_user_id: "user_002", email: "bob@example.com", point_balance: 1200 },
  { clerk_user_id: "user_003", email: "carol@example.com", point_balance: 0 }
].map do |attrs|
  User.find_or_create_by!(clerk_user_id: attrs[:clerk_user_id]) do |user|
    user.email = attrs[:email]
    user.point_balance = attrs[:point_balance]
  end
end

# --- Products ---
products = [
  { title: "SPI自動実行ファイル", description: "SPI問題を自動で解くツール一式", point_price: 300, file_url: "https://example.com/files/spi_tool.zip", thumbnail_url: "https://example.com/thumbs/spi_tool.png" },
  { title: "AI生成PDF集", description: "AIに作成させたPDFのまとめ集", point_price: 200, file_url: "https://example.com/files/ai_pdfs.zip", thumbnail_url: "https://example.com/thumbs/ai_pdfs.png" },
  { title: "料理レシピPDF集", description: "簡単に作れる料理レシピ集", point_price: 150, file_url: "https://example.com/files/recipes.pdf", thumbnail_url: "https://example.com/thumbs/recipes.png" },
  { title: "Goエンジニアロードマップ", description: "Goエンジニアになるための学習ロードマップ", point_price: 250, file_url: "https://example.com/files/go_roadmap.pdf", thumbnail_url: "https://example.com/thumbs/go_roadmap.png" },
  { title: "システム設計集(SNS/EC)", description: "SNS設計・EC設計のシステム設計資料集", point_price: 400, file_url: "https://example.com/files/system_design.pdf", thumbnail_url: "https://example.com/thumbs/system_design.png" },
  { title: "IT企業Tier表", description: "エンジニア向けIT企業のTier表", point_price: 100, file_url: "https://example.com/files/it_tier.pdf", thumbnail_url: "https://example.com/thumbs/it_tier.png" },
  { title: "Dockerテンプレート集", description: "すぐ使えるDockerテンプレート集", point_price: 200, file_url: "https://example.com/files/docker_templates.zip", thumbnail_url: "https://example.com/thumbs/docker_templates.png" },
  { title: "AtCoder問題集", description: "AtCoder過去問のまとめ問題集", point_price: 300, file_url: "https://example.com/files/atcoder.pdf", thumbnail_url: "https://example.com/thumbs/atcoder.png" }
].map do |attrs|
  Product.find_or_create_by!(title: attrs[:title]) do |product|
    product.description = attrs[:description]
    product.point_price = attrs[:point_price]
    product.file_url = attrs[:file_url]
    product.thumbnail_url = attrs[:thumbnail_url]
    product.is_active = true
  end
end

alice, bob, carol = users
spi_tool, ai_pdfs, = products

# --- Point logs (ポイント獲得・消費の履歴) ---
point_logs = [
  { user: alice, log_type: "github_commit", point: 50, description: "GitHubへのコミット" },
  { user: alice, log_type: "login_bonus", point: 10, description: "ログインボーナス" },
  { user: alice, log_type: "purchase", point: -300, description: "「#{spi_tool.title}」を購入" },
  { user: bob, log_type: "qiita_post", point: 100, description: "Qiita投稿" },
  { user: bob, log_type: "referral", point: 200, description: "友達紹介" },
  { user: bob, log_type: "purchase", point: -200, description: "「#{ai_pdfs.title}」を購入" }
]

point_logs.each do |attrs|
  PointLog.find_or_create_by!(user: attrs[:user], log_type: attrs[:log_type], description: attrs[:description]) do |log|
    log.point = attrs[:point]
  end
end

# --- Purchases ---
purchases = [
  { user: alice, product: spi_tool, point_used: 300 },
  { user: bob, product: ai_pdfs, point_used: 200 }
].map do |attrs|
  Purchase.find_or_create_by!(user: attrs[:user], product: attrs[:product]) do |purchase|
    purchase.point_used = attrs[:point_used]
  end
end

alice_purchase, bob_purchase = purchases

# --- Mail logs (商品送付メールの記録) ---
[
  { purchase: alice_purchase, mail_type: "product_delivery", recipient_email: alice.email, subject: "「#{spi_tool.title}」をお届けします", status: "sent" },
  { purchase: bob_purchase, mail_type: "product_delivery", recipient_email: bob.email, subject: "「#{ai_pdfs.title}」をお届けします", status: "sent" }
].each do |attrs|
  MailLog.find_or_create_by!(purchase: attrs[:purchase], mail_type: attrs[:mail_type]) do |mail_log|
    mail_log.recipient_email = attrs[:recipient_email]
    mail_log.subject = attrs[:subject]
    mail_log.status = attrs[:status]
    mail_log.sent_at = Time.current
  end
end

puts "Seed data created: #{User.count} users, #{Product.count} products, #{Purchase.count} purchases, #{PointLog.count} point_logs, #{MailLog.count} mail_logs"
