class Api::MailLogsController < ApplicationController
  def index
    mail_logs = MailLog.all
    # purchase_id が指定された場合のみ絞り込む（未指定なら全件返す）
    mail_logs = mail_logs.where(purchase_id: params[:purchase_id]) if params[:purchase_id].present?
    render json: mail_logs
  end

  def show
    render json: MailLog.find(params[:id])
  end
end
