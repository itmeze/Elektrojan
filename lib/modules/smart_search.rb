module SmartSearch
  def self.included(base)
    base.class_eval do
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
  end
end
