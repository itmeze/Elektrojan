#encoding: utf-8
class Guaranteereport < ActiveRecord::Base
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

      search = "%#{q}%"
      where('name like ? or address like ? or phone like ? or email like ? or producer like ? or description like ? or purchase_place like ? or rodzaj like ? or pin like ?', search, search, search, search, search, search, search, search, search)
    }

  scope :before, lambda { |dt|
    return unless dt.present?

    where('created_at < ?', Date.strptime(dt, '%d/%m/%Y'))
  }

  scope :after, lambda { |dt|
    return unless dt.present?

    where('created_at > ?', Date.strptime(dt, '%d/%m/%Y'))
  }


end
