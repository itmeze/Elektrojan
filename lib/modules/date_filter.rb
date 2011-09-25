require 'components/safe_date_parser'

module DateFilter

  def self.included(base)
    base.class_eval do
      scope :before, lambda { |dt|
        return unless dt.present?
        parser = SafeDateParser.new
        where('created_at < ?', parser.parse(dt))
      }

      scope :after, lambda { |dt|
        return unless dt.present?
        parser = SafeDateParser.new
        where('created_at > ?', parser.parse(dt))
      }
    end
  end
end
