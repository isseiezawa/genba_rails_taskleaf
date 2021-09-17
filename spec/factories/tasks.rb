FactoryBot.define do
    factory :task do
        name { 'テストを書く' }
        description { 'RSpec & Capybara & FactoryBotを準備する' }
        user
    end
end

# users.rbに定義した :userという名前のFactoryを、Taskモデルに定義されたuserという名前の関連を生成するのに利用する