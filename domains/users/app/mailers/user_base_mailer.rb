class UserBaseMailer < ApplicationMailer
  prepend_view_path(Rails.root.join("domains/users/app/views"))
end
