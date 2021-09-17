# 一覧画面に遷移(せんい)したら作成済みのタスクが表示されている
require 'rails_helper'

describe 'タスク管理機能', type: :system do
    let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@exanple.com') }
    let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
    let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }
    # let!は強制発動。作成者がユーザーAであるタスクを作成しておく
    before do
        # ユーザーAでログインする
        visit login_path # ログイン画面にアクセス / visit[URL]で特定のURLへ
        # テキストフィールドに値を入れる'fill_in'ラベルと入力値を指定
        fill_in 'メールアドレス', with: login_user.email # メールアドレスの入力
        fill_in 'パスワード', with: login_user.password # パスワードの入力
        click_button 'ログインする' # 「ログインする」ボタンを押す
    end

    # itの共通化。exampleとはitなどの期待する挙動を示す部分。
    shared_examples_for 'ユーザーAが作成したタスクが表示される' do
        it  { expect(page).to have_content '最初のタスク' }
        # 作成済みのタスクの名称が画面上に表示されていることを確認
        # beforeで登録するようにしたユーザーAが作成者になっているタスクが表示されているか
        # expect(page).to => page(画面)に期待するよ‥することを
        # havecontent '最初のタスク' => あるはずだよね、「最初のタスク」という内容が。 / 「マッチャ(Matcher)」と呼ばれる
    end
    
    describe '一覧表示機能' do
        context 'ユーザーAがログインしている時' do
            let(:login_user) { user_a }

            # shared_examples_forを利用するという書き方↓
            it_behaves_like 'ユーザーAが作成したタスクが表示される'
        end

        context 'ユーザーBがログインしている時' do
            let(:login_user) { user_b }

            it 'ユーザーAが作成したタスクが表示されない' do
                # ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
                expect(page).to have_no_content '最初のタスク' # 表示されていないことを期待するので、have_no_content
            end
        end
    end

    describe '詳細表示機能' do
        context 'ユーザーAがログインしている時' do
            let(:login_user) { user_a }

            before do
                visit task_path(task_a)
            end

            it_behaves_like 'ユーザーAが作成したタスクが表示される'
        end
    end

    describe '新規作成機能' do
        let(:login_user) { user_a }

        before do
            visit new_task_path
            fill_in '名称', with: task_name # ① contextで、名称を入力するかしないか受け取っている
            click_button '登録する'
        end

        context '新規作成画面で名称を入力した時' do
            let(:task_name) { '新規作成のテストを書く' }

            it '正常に登録される' do
                expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く' # ②
                # have_selectorでHTML内の特定の要素をセレクタ(CSSセレクタ)で指定可能
                # alert-successというCSS、テキストに'新規作成のテストを書く'を含む要素があるか検査
                # alert-successはFlashメッセージ。"タスク「新規作成を書く」を登録しました"を検知している
            end
        end

        context '新規作成画面で名称を入力しなかった時' do
            let(:task_name) { '' }

            it 'エラーとなる' do
                within '#error_explanation' do # ③
                    expect(page).to have_content '名称を入力してください'
                end
                # withinブロック内でpage内容を検査することで探索する範囲を限定する
                # #error_explanationというid要素、検証エラーを表示する領域内に「名称を入力してください」というメッセージが含まれているかどうか検証
            end
        end
    end
end

# contextの外側のbeforeはそれぞれのcontextが呼び出される前に実行される。よってどちらでもユーザーAが作成される処理が実行される
# $ bundle exec rspec spec/system/tasks_spec.rb で実行
# i example, 0 failures => １件のテストをして失敗は０件