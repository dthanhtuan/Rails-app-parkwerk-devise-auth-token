module Users
  class UserBaseMailer < ApplicationMailer
    append_view_path(Rails.root.join("domains/users/app/views"))
  end
end
