#encoding: utf-8
class Notifications < ActionMailer::Base
  default from: "from@example.com"

  attr_accessor :to_email

  def order(order)
    @order = order

    set_attachments @order
    logger.info 'real sending email'
    mail(:to => MyConfiguration.mailer_to, :subject => 'Złożenie zamówienia - ' + @order.name)
    logger.info 'after real sending email'
  end

  def guarantee_report(report)
    @report = report

    set_attachments @report
    logger.info 'real sending email'
    mail(:to => MyConfiguration.mailer_to, :subject => 'Zgłoszenie gwarancyjne - ' + @report.name )
    logger.info 'after real sending info'
  end

  def postguarantee_report(report)
    @report = report

    set_attachments @report

    logger.info 'real sending email'
    mail(:to => MyConfiguration.mailer_to, :subject => 'Zgłoszenie pogwarancyjne - ' + @report.name)
    logger.info 'after real sending email'
  end

  def set_attachments(model)

    attachments[model.image1_identifier] = File.read(model.image1.current_path) if model.respond_to?(:image1) && model.image1.present?
    attachments[model.image2_identifier] = File.read(model.image2.current_path) if model.respond_to?(:image2) && model.image2.present?
    attachments[model.image3_identifier] = File.read(model.image3.current_path) if model.respond_to?(:image3) && model.image3.present?
  end
end

