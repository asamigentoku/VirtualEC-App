class Api::PointLogsController < ApplicationController
  def index
    # 新しい履歴から順に表示されるよう作成日時の降順で並べる
    point_logs = PointLog.order(created_at: :desc)
    # user_id が指定された場合のみ絞り込む（未指定なら全ユーザー分を返す）
    point_logs = point_logs.where(user_id: params[:user_id]) if params[:user_id].present?
    render json: point_logs
  end
end
