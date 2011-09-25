# encoding: utf-8
require 'modules/date_filter'

class Order < ActiveRecord::Base
  include DateFilter
  mount_uploader :image1, AttachmentUploader
  mount_uploader :image2, AttachmentUploader
  mount_uploader :image3, AttachmentUploader

  validates :name, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256, :message => 'Pole zbyt długie' }
  validates :address, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256 }
  validates :phone, :presence => { :message => 'Pole jest wymagane' }, :length => { :maximum => 256 }
  validates :email,
            :allow_blank => true,
            :format =>
                { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'Niewłaściwy format'  },
            :length => { :maximum => 256 }
  validates :order_description,
            :presence =>  { :message => 'Pole jest wymagane' },
            :length => { :maximum => 256 }

  scope :search, lambda { |q|
    return unless q.present?

    search = "%#{q}%"
    where('name like ? or address like ? or phone like ? or email like ? or producer like ? or product_name like ? or order_description like ? ', search, search, search, search, search, search, search)
  }
end
