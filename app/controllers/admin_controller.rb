#encoding: utf-8
class AdminController < ApplicationController
  http_basic_authenticate_with :name => 'jajanek', :password => 'test'

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

    flash[:notice] = "Rekord usunięty"
    redirect_to :action => 'index', :flash => 'Rekord usunięty'
  end

  def add_comment
    id = params[:id]
    type = params[:type]
    comment = params[:comment]

    if (type == 'order')
      @element = Order.where(:id => id).first
    end

    if (type == 'guaranteereport')
      @element = Guaranteereport.where(:id => id).first
    end

    if (type == 'postguaranteereport')
      @element = Postguaranteereport.where(:id => id).first
    end

    @element.comment = comment
    @element.save

    flash[:notice] = 'Komentarz dodany poprawnie'

    redirect_to :action => 'details', :id => params[:id], :type => params['type']
  end
end

