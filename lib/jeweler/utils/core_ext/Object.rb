class Object
  def number?
    begin
      result = Float(number)
      return result if result
    rescue ArgumentError
      false
    end
    false
  end
end
