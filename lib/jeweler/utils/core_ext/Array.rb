class Array
  # Logs all of these errors, as errors, prefixed with the param (optionally)
  def log_errors(prefix_msg = nil)
    each do |e|
      if prefix_msg.nil?
        Rails.logger.error e
      else
        Rails.logger.error prefix_msg + ': ' + e
      end
    end
  end
  def build_errors
    each do |e|
      @errors << e
    end
  end
end