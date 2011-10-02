#encoding: utf-8

require 'modules/date_filter'

class Guaranteereport < ActiveRecord::Base
  include DateFilter
  validates :name, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256, :message => 'Pole zbyt długie' }
  validates :address, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256 }
  validates :phone, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256 }
  validates :email,
            :allow_blank => true,
            :format =>
                { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'Niewłaściwy format'  },
            :length => { :maximum => 256 }
  validates :purchase_date, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256 }
  validates :purchase_place, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256 }
  validates :purchase_id, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256 }
  validates :rodzaj, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256 }
  validates :description,
            :presence =>  { :message => 'Pole jest wymagane' },
            :length => { :maximum => 256 }

  scope :search, lambda { |q|
    return unless q.present?

    query = ""
    search = "%#{q}%"

    multi_argument = []

    self.columns.each do |c|
      query << "#{c.name} like ? or "
      multi_argument << search
    end

    query = query[0..(query.length - " or ".length)]
    where( query, *multi_argument )
  }
end
