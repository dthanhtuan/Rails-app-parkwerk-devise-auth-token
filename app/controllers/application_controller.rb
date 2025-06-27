class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  include DeviseTokenAuth::Concerns::SetUserByToken

  append_view_path(Dir.glob(Rails.root.join("domains/**/app/views")))
end
