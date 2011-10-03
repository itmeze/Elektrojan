#encoding: utf-8
class AdminController < ApplicationController

  def index
  end

  def search

    type = params[:type]
    q = params[:q]
    from = params[:from]
    to = params[:to]

    @elements = Array.new

    unless (type.present? && type != 'order')
      Order.search(q).after(from).before(to).each { |p| @elements << p }
    end

    unless (type.present? && type != 'guarantee')
      Guaranteereport.search(q).after(from).before(to).each { |p| @elements << p  }
    end

    unless (type.present? && type != 'postguarantee')
      Postguaranteereport.search(q).after(from).before(to).each { |p| @elements << p }
    end

    @elements = @elements.sort{ |a, b| b.created_at <=> a.created_at }.take(20)

    render :layout => false
  end

  def details
    type = params[:type]
    id = params[:id]

    if (type == 'order')
      @element = Order.where(:id => id).first
    end

    if (type == 'guaranteereport')
      @element = Guaranteereport.where(:id => id).first
    end

    if (type == 'postguaranteereport')
      @element = Postguaranteereport.where(:id => id).first
    end

  end

  def delete
    id = params[:id]
    type = params[:type]

    if (type == 'order')
      @element = Order.where(:id => id).first
    end

    if (type == 'guaranteereport')
      @element = Guaranteereport.where(:id => id).first
    end

    if (type == 'postguaranteereport')
      @element = Postguaranteereport.where(:id => id).first
    end

    @element.destroy unless @element.nil?

    redirect_to :action => 'index', :flash => 'Element usunięty'
  end

end

