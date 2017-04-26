class Micropost < ActiveRecord::Base
    belongs_to :user
    default_scope -> { order('created_at DESC') }
    validates :content, presence: true, length: { maximum: 300 }
    validates :user_id, presence: true

  # ファイル用の属性を追加するhas_attached_fileメソッド
  has_attached_file :image, styles: { medium: "200x150>", thumb: "50x50>" }

  #  画像の拡張子を限定するためのvalidatorを定義
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png image/gif)

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end


__END__
コード3ではむしろ下のから上のになっているのに、なぜかコード4で戻る。
でも、コード4のように戻す前ではなぜか実装できないため、変更。
          user_id: user.id)
変更すると、むしろエラーになった。なぜ？
理由判明。
10行目、IN以降の部分。最初コード3で(:followed_user_ids)と記述していたが、
間違い。コード4で(#{followed_user_ids})と成っている。
{}の使用と、その外で(#{})でくくっている点。
これが何の意味をもたらすのかは後ほど確認。
というか、どうしてかそれでもエラーが出るためこの部分コピペ。
すると直った。
つまり、打ちミス。