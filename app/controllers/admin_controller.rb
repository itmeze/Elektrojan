#encoding: utf-8
require 'search_conditions'

class AdminController < ApplicationController
  http_basic_authenticate_with :name => MyConfiguration.admin_username, :password => MyConfiguration.admin_password
  before_filter :fill_common_data

  def fill_common_data
    @types = [
                ["WSZYSTKIE", nil],
                ["Zamówienie części", 'order'],
                ["Zgłoszenie gwarancyjne", "guarantee"],
                ["Zgłoszenie pogwarancyjne", "postguarantee"]
             ]
  end

  def index
    if params[:reload].nil? && session[:search].present?
      @query = session[:search]
    end
    @query ||= SearchConditions.new
  end

  def search

    search = SearchConditions.new params[:search_conditions]

    session[:search] = search

    @elements = Array.new

    unless (search.type.present? && search.type != 'order')
      Order.search(search.q).after(search.from).before(search.to).each { |p| @elements << p }
    end

    unless (search.type.present? && search.type != 'guarantee')
      Guaranteereport.search(search.q).after(search.from).before(search.to).each { |p| @elements << p  }
    end

    unless (search.type.present? && search.type != 'postguarantee')
      Postguaranteereport.search(search.q).after(search.from).before(search.to).each { |p| @elements << p }
    end

    @elements = @elements.sort{ |a, b| b.created_at <=> a.created_at }.take(30)

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

