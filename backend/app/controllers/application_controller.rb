class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionView::Layouts

  append_view_path "#{Rails.root}/app/views"

  # 全コントローラ共通のエラーハンドリング。
  # rescue_from を使うことで、各アクションに毎回 begin/rescue を書かずに済み、
  # 想定外の例外がそのまま素のRailsエラー画面・500エラーとして返ってしまうのを防ぐ。

  # find(id) で該当レコードが無いときに発生する例外 → 404として返す
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  # create!/update! でバリデーションに失敗したときに発生する例外 → 422として返す
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable

  private

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_unprocessable(exception)
    render json: { error: exception.record.errors.full_messages.join(", ") }, status: :unprocessable_entity
  end
end
