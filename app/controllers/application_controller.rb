#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def hidden_field_valid?
    if MyConfiguration.display_spam_hidden_field && params[MyConfiguration.spam_hidden_field_name].present?
      false
    else
      true
    end
  end

  def captcha_valid?(model)
    return MyConfiguration.display_captcha || verify_recaptcha(:model => model, :message => "Niewłaściwie przepisany kod! Przepisz ponownie, pamietaj o ponownym załączeniu plików!", :attribute => 'recaptcha')
  end
end
