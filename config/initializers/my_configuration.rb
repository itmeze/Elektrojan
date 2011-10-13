class MyConfiguration
  class << self
    attr_accessor :mailer_to,
      :items_on_list,
      :display_captcha,
      :display_spam_hidden_field,
      :spam_hidden_field_name
  end
end
