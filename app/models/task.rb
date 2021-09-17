class Task < ApplicationRecord
    validates :name, presence: true, length: { maximum: 30 }
    validate :validate_name_not_including_comma
    # before_validation :set_nameless_name

    belongs_to :user

    scope :recent, -> { order(created_at: :desc) } 
    # scorpeを使うと繰り返し利用される絞り込み条件をスッキリ読みやすくできる
    # クエリー用のメソッドの連続した呼び出し部分をまとめて名前をつけて、カスタム用のメソッドとして使う。

    private

    def validate_name_not_including_comma
        errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
    end

    # def set_nameless_name
    #     self.name = '名前なし' if name.blank?
    # end
end
