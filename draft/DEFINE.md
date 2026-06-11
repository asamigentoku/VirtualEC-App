## 具体的な機能の設計

ログインはCleak

## メールの欄は
Resendを利用する

## データ
S3の利用

# エンドポイント一覧

| # | メソッド | パス | 役割 |
|---|---|---|---|
| ① | POST | `/api/v1/auth/sync` | Clerkログイン後のユーザー登録 |
| ② | GET | `/api/v1/me` | 自分の情報＋残高 |
| ③ | GET | `/api/v1/me/point_logs` | ポイント履歴 |
| ④ | GET | `/api/v1/products` | 商品一覧 |
| ⑤ | GET | `/api/v1/products/:id` | 商品詳細 |
| ⑥ | POST | `/api/v1/purchases` | 購入（メイン処理） |
| ⑦ | GET | `/api/v1/purchases` | 購入履歴 |
| ⑧ | GET | `/api/v1/purchases/:id/download` | PDF署名付きURL発行 |