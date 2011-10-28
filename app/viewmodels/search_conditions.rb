require 'active_record'

class SearchConditions
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :type, :q, :from, :to

  def initialize (attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end unless attributes.nil?
  end

  def persisted?
    false
  end

  def load (query_params=nil)
    unless query_params.nil?
      @type = query_params[:type]
      @q = query_params[:q]
      @from = query_params[:from]
      @to = query_params[:to]
    end
  end
end
