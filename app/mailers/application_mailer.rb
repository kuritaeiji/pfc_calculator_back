class ApplicationMailer < ActionMailer::Base
  default(from: 'pfc-calculator@heroku.com', from_display_name: 'PFC計算機')
  layout 'mailer'
end
