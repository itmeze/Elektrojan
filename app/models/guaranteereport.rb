#encoding: utf-8

require 'modules/date_filter'
require 'modules/smart_search'

class Guaranteereport < ActiveRecord::Base
  include DateFilter
  include SmartSearch
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


  def type_to_s
    "Zgłoszenie grawancyjne"
  end
  def simple_type
    "guaranteereport"
  end
end
