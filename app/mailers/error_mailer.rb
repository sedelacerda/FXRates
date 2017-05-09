class ErrorMailer < ApplicationMailer

  default from: 'projectyapo@gmail.com'
  layout "mailer"
  
  def notify_error_email(provider)
    subj = 'Error en FXRates en provider '+provider
    mail(to: "sebadelacerda@gmail.com", subject: subj)
  end

end
