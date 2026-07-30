# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# --- Users ---
users = [
  { clerk_user_id: "user_001", email: "alice@example.com",   point_balance: 500  },
  { clerk_user_id: "user_002", email: "bob@example.com",     point_balance: 1200 },
  { clerk_user_id: "user_003", email: "carol@example.com",   point_balance: 0    },
  { clerk_user_id: "user_004", email: "dave@example.com",    point_balance: 750  },
  { clerk_user_id: "user_005", email: "eve@example.com",     point_balance: 300  },
  { clerk_user_id: "user_006", email: "frank@example.com",   point_balance: 2000 },
  { clerk_user_id: "user_007", email: "grace@example.com",   point_balance: 50   },
  { clerk_user_id: "user_008", email: "hiro@example.com",    point_balance: 900  },
  { clerk_user_id: "user_009", email: "ito@example.com",     point_balance: 150  },
  { clerk_user_id: "user_010", email: "julia@example.com",   point_balance: 600  }
].map do |attrs|
  User.find_or_create_by!(clerk_user_id: attrs[:clerk_user_id]) do |user|
    user.email         = attrs[:email]
    user.point_balance = attrs[:point_balance]
  end
end

# --- Products ---
products = [
  { title: "SPI自動実行ファイル",          description: "SPI問題を自動で解くツール一式",                         point_price: 300, file_url: "https://example.com/files/spi_tool.zip",          thumbnail_url: "https://example.com/thumbs/spi_tool.png"         },
  { title: "AI生成PDF集",                  description: "AIに作成させたPDFのまとめ集",                           point_price: 200, file_url: "https://example.com/files/ai_pdfs.zip",           thumbnail_url: "https://example.com/thumbs/ai_pdfs.png"          },
  { title: "料理レシピPDF集",              description: "簡単に作れる料理レシピ集",                             point_price: 150, file_url: "https://example.com/files/recipes.pdf",           thumbnail_url: "https://example.com/thumbs/recipes.png"          },
  { title: "Goエンジニアロードマップ",     description: "Goエンジニアになるための学習ロードマップ",             point_price: 250, file_url: "https://example.com/files/go_roadmap.pdf",        thumbnail_url: "https://example.com/thumbs/go_roadmap.png"       },
  { title: "システム設計集(SNS/EC)",       description: "SNS設計・EC設計のシステム設計資料集",                 point_price: 400, file_url: "https://example.com/files/system_design.pdf",    thumbnail_url: "https://example.com/thumbs/system_design.png"   },
  { title: "IT企業Tier表",                 description: "エンジニア向けIT企業のTier表",                         point_price: 100, file_url: "https://example.com/files/it_tier.pdf",           thumbnail_url: "https://example.com/thumbs/it_tier.png"          },
  { title: "Dockerテンプレート集",         description: "すぐ使えるDockerテンプレート集",                       point_price: 200, file_url: "https://example.com/files/docker_templates.zip",  thumbnail_url: "https://example.com/thumbs/docker_templates.png" },
  { title: "AtCoder問題集",               description: "AtCoder過去問のまとめ問題集",                          point_price: 300, file_url: "https://example.com/files/atcoder.pdf",           thumbnail_url: "https://example.com/thumbs/atcoder.png"          },
  { title: "Rubyベストプラクティス集",     description: "現場で使えるRubyのイディオムと設計パターン集",         point_price: 250, file_url: "https://example.com/files/ruby_best.pdf",         thumbnail_url: "https://example.com/thumbs/ruby_best.png"        },
  { title: "Next.js App Router入門",       description: "App RouterとServer Componentsを使った実践ガイド",      point_price: 300, file_url: "https://example.com/files/nextjs_approuter.pdf", thumbnail_url: "https://example.com/thumbs/nextjs_approuter.png" },
  { title: "TypeScript型定義チートシート", description: "よく使うTypeScriptの型パターンをまとめたチートシート", point_price: 100, file_url: "https://example.com/files/ts_cheatsheet.pdf",    thumbnail_url: "https://example.com/thumbs/ts_cheatsheet.png"   },
  { title: "AWSインフラ構成テンプレート",  description: "本番運用で使えるAWS構成のTerraformテンプレート集",   point_price: 500, file_url: "https://example.com/files/aws_terraform.zip",      thumbnail_url: "https://example.com/thumbs/aws_terraform.png"    },
  { title: "エンジニア転職テンプレ集",     description: "職務経歴書・ポートフォリオのテンプレートセット",       point_price: 150, file_url: "https://example.com/files/career_templates.zip",  thumbnail_url: "https://example.com/thumbs/career_templates.png" },
  { title: "SQL入門から中級チートシート",  description: "JOIN・サブクエリ・インデックスまで網羅したSQL資料",   point_price: 200, file_url: "https://example.com/files/sql_cheatsheet.pdf",    thumbnail_url: "https://example.com/thumbs/sql_cheatsheet.png"   },
  { title: "個人開発マネタイズ戦略PDF",    description: "個人開発で収益を出すためのマネタイズ手法まとめ",     point_price: 350, file_url: "https://example.com/files/monetize.pdf",          thumbnail_url: "https://example.com/thumbs/monetize.png"         }
].map do |attrs|
  Product.find_or_create_by!(title: attrs[:title]) do |product|
    product.description   = attrs[:description]
    product.point_price   = attrs[:point_price]
    product.file_url      = attrs[:file_url]
    product.thumbnail_url = attrs[:thumbnail_url]
    product.is_active     = true
  end
end

alice, bob, carol, dave, eve, frank, grace, hiro, ito, julia = users
spi_tool, ai_pdfs, recipes, go_roadmap, system_design,
  it_tier, docker, atcoder, ruby_best, nextjs,
  ts_sheet, aws_tf, career, sql_sheet, monetize = products

# --- Point logs ---
point_logs = [
  # alice
  { user: alice, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: alice, log_type: "login_bonus",   point: 10,   description: "ログインボーナス" },
  { user: alice, log_type: "qiita_post",    point: 100,  description: "Qiita記事投稿" },
  { user: alice, log_type: "purchase",      point: -300, description: "「#{spi_tool.title}」を購入" },

  # bob
  { user: bob, log_type: "qiita_post",    point: 100,  description: "Qiita投稿" },
  { user: bob, log_type: "referral",      point: 200,  description: "友達紹介ボーナス" },
  { user: bob, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: bob, log_type: "github_commit", point: 50,   description: "GitHubへのコミット（2回目）" },
  { user: bob, log_type: "admin_grant",   point: 1000, description: "管理者ポイント付与（キャンペーン）" },
  { user: bob, log_type: "purchase",      point: -200, description: "「#{ai_pdfs.title}」を購入" },

  # carol
  { user: carol, log_type: "login_bonus", point: 10, description: "ログインボーナス" },

  # dave
  { user: dave, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: dave, log_type: "qiita_post",    point: 100,  description: "Qiita記事投稿" },
  { user: dave, log_type: "referral",      point: 200,  description: "友達紹介ボーナス" },
  { user: dave, log_type: "login_bonus",   point: 10,   description: "ログインボーナス" },
  { user: dave, log_type: "purchase",      point: -250, description: "「#{go_roadmap.title}」を購入" },
  { user: dave, log_type: "purchase",      point: -100, description: "「#{it_tier.title}」を購入" },

  # eve
  { user: eve, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: eve, log_type: "login_bonus",   point: 10,   description: "ログインボーナス" },
  { user: eve, log_type: "purchase",      point: -150, description: "「#{recipes.title}」を購入" },

  # frank
  { user: frank, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: frank, log_type: "qiita_post",    point: 100,  description: "Qiita記事投稿" },
  { user: frank, log_type: "qiita_post",    point: 100,  description: "Qiita記事投稿（2本目）" },
  { user: frank, log_type: "referral",      point: 200,  description: "友達紹介ボーナス" },
  { user: frank, log_type: "admin_grant",   point: 500,  description: "管理者ポイント付与" },
  { user: frank, log_type: "purchase",      point: -400, description: "「#{system_design.title}」を購入" },
  { user: frank, log_type: "purchase",      point: -200, description: "「#{docker.title}」を購入" },

  # grace
  { user: grace, log_type: "login_bonus",   point: 10,   description: "ログインボーナス" },
  { user: grace, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: grace, log_type: "purchase",      point: -100, description: "「#{ts_sheet.title}」を購入" },

  # hiro
  { user: hiro, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: hiro, log_type: "qiita_post",    point: 100,  description: "Qiita記事投稿" },
  { user: hiro, log_type: "referral",      point: 200,  description: "友達紹介ボーナス" },
  { user: hiro, log_type: "login_bonus",   point: 10,   description: "ログインボーナス" },
  { user: hiro, log_type: "purchase",      point: -300, description: "「#{atcoder.title}」を購入" },
  { user: hiro, log_type: "purchase",      point: -250, description: "「#{ruby_best.title}」を購入" },

  # ito
  { user: ito, log_type: "login_bonus",   point: 10,   description: "ログインボーナス" },
  { user: ito, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: ito, log_type: "purchase",      point: -150, description: "「#{career.title}」を購入" },

  # julia
  { user: julia, log_type: "github_commit", point: 50,   description: "GitHubへのコミット" },
  { user: julia, log_type: "qiita_post",    point: 100,  description: "Qiita記事投稿" },
  { user: julia, log_type: "referral",      point: 200,  description: "友達紹介ボーナス" },
  { user: julia, log_type: "login_bonus",   point: 10,   description: "ログインボーナス" },
  { user: julia, log_type: "purchase",      point: -200, description: "「#{sql_sheet.title}」を購入" },
  { user: julia, log_type: "purchase",      point: -300, description: "「#{nextjs.title}」を購入" }
]

point_logs.each do |attrs|
  PointLog.find_or_create_by!(
    user:        attrs[:user],
    log_type:    attrs[:log_type],
    description: attrs[:description]
  ) do |log|
    log.point = attrs[:point]
  end
end

# --- Purchases ---
purchases = [
  { user: alice, product: spi_tool,      point_used: 300 },
  { user: bob,   product: ai_pdfs,       point_used: 200 },
  { user: dave,  product: go_roadmap,    point_used: 250 },
  { user: dave,  product: it_tier,       point_used: 100 },
  { user: eve,   product: recipes,       point_used: 150 },
  { user: frank, product: system_design, point_used: 400 },
  { user: frank, product: docker,        point_used: 200 },
  { user: grace, product: ts_sheet,      point_used: 100 },
  { user: hiro,  product: atcoder,       point_used: 300 },
  { user: hiro,  product: ruby_best,     point_used: 250 },
  { user: ito,   product: career,        point_used: 150 },
  { user: julia, product: sql_sheet,     point_used: 200 },
  { user: julia, product: nextjs,        point_used: 300 }
].map do |attrs|
  Purchase.find_or_create_by!(user: attrs[:user], product: attrs[:product]) do |purchase|
    purchase.point_used = attrs[:point_used]
  end
end

# --- Mail logs ---
purchases.each do |purchase|
  MailLog.find_or_create_by!(purchase: purchase, mail_type: "product_delivery") do |mail_log|
    mail_log.recipient_email = purchase.user.email
    mail_log.subject         = "「#{purchase.product.title}」をお届けします"
    mail_log.status          = "sent"
    mail_log.sent_at         = Time.current
  end
end

puts "Seed data created: #{User.count} users, #{Product.count} products, #{Purchase.count} purchases, #{PointLog.count} point_logs, #{MailLog.count} mail_logs"