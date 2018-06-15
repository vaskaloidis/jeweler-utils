# These, as well as the methods above are for displaying these numbers in the UI. I prefer these cleaner methods to the decorator pattern (in these few use-cases), because it is really really clean.
class NilClass

  # Returns 0
  def prettify
    return 0
  end

  # Returns '0 hr.'
  def hours
    return '0 hr.'
  end

  # Returns '$0'
  def money
    return '$0'
  end

  # Returns False
  def true?
    return false
  end

  # Returns False
  def to_b
    return false
  end
end