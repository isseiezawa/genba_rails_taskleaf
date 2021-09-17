# ログインの動作を確認する為に事前にデータベースにUserデータを登録する
# Userのファクトリ(データを作成することを簡単にする仕組み)を追加

FactoryBot.define do
    factory :user do
        name { 'テストユーザー' }
        email { 'test1@example.com' }
        password { 'password' }
    end
end

# factoryメソッドを利用して :userという名前のUserクラスのファクトリを定義している