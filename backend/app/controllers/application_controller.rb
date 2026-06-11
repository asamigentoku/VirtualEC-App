class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionView::Layouts

  append_view_path "#{Rails.root}/app/views"
end
