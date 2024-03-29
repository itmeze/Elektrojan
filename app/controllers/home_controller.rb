# encoding: utf-8
class HomeController < ApplicationController
  before_filter :fill_data

  def fill_data
    @producers = ["Albatros", "Artweger", "Duschy", "Excellent", "Grohe", "Jacuzzi", "Koło", "Koralle"]
    @guarantee_producers = ["Koło", "Artweger", "Grohe"]
    @report_types = [ ["Zgłoszenie gwarancyjne", "true"], ["Zgłoszenie pogwarancyjne", "false"] ]
    @config = MyConfiguration
  end

  def index
  end

  def order
    @order = Order.new
  end

  def submit_order
    @order = Order.new params[:order]

    return render 'order' unless hidden_field_valid?

    if captcha_valid?(@order) && @order.save
      fork do
        Notifications.order(@order).deliver
      end
      redirect_to :action => 'thankyou_for_order'
    else
      render 'order'
    end
  end

  def report
    @report = Guaranteereport.new
    @report_type = true
  end

  def submit_guarantee_report
    @report = Guaranteereport.new(params[:guaranteereport])
    @report_type = true

    return render 'report' unless hidden_field_valid?

    if captcha_valid?(@report) && @report.save
      fork do
        Notifications.guarantee_report(@report).deliver
      end
      redirect_to :action => 'thankyou_for_report'
    else
      render 'report'
    end
  end

  def submit_postguarantee_report
    @report = Postguaranteereport.new params[:postguaranteereport]
    @report_type = false

    return render 'report' unless hidden_field_valid?
    if captcha_valid?(@report) && @report.save
      fork do
        Notifications.postguarantee_report(@report).deliver
      end
      redirect_to :action => 'thankyou_for_report'
    else
      render 'report'
    end
  end

  def display_form
    @report_type = params[:report_type].to_s
    if @report_type == "true"
      @report = Guaranteereport.new
      render '_guarantee_report', :layout => nil
    else
      @report = Postguaranteereport.new
      render '_post_guarantee_report', :layout => nil
    end
  end

  def thankyou_for_order
    render 'thankyou_for_order'
  end

  def thankyou_for_report
    render 'thankyou_for_report'
  end

end
