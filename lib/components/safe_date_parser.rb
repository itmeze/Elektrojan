class SafeDateParser
  attr_accessor :accepted_formats

  def initialize(formats = nil)
    unless formats.nil? || !formats.respond_to?(:each)
      @accepted_formats = formats
    else
      @accepted_formats = ['%d/%m/%Y', '%d.%m.%Y']
    end
  end

  def parse (dt)
    accepted_formats.each do |format|
      begin
        return Date.strptime(dt, format)
      rescue
        next
      end
    end

    nil
  end
end
