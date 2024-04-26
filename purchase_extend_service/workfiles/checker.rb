class Checker
  def missing_params(params)
    require_params = %w[booking_number name age document_number document_type]
    missing_params = require_params.select { |param| params[params].nil?}
  end
end