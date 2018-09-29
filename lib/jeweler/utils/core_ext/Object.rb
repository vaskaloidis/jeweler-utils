class Object
  def number?
    begin
      result = Float(self)
      return true if result
    rescue ArgumentError
      false
    end
    false
  end
end
