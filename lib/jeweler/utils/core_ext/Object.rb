class Object
  def is_number?
    Float(number) || BigDecimal(number) || Integer(number)
    true
  rescue ArgumentError
    false
  end
end
