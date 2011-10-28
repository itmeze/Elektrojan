class QueryPreserver
  @allowed_params = [:type, :q, :from, :to]

  attr_accessor :inner_hash

  def initilize org_hash
    @inner_hash = Hash.new
    allowed_params.each do |p|
      @inner_hash[p.to_s] = org_hash[p.to_s]
    end
  end
end
