# Namespace for the Jeweler Logger used for Auditing, Debugging Issues
# through logs, and Overall Error-rporting
module Logger

  # Logger to be used ONLY during Controller logging because it accesses
  # the @params [Hash] for @params[:action] and @params[:controller]
  def action_log
    rails_action = "#{ params[:controller] }##{ params[:action] }"
    rails_params = params.except(:controller, :action)

    # Search for the project ID
    # @todo Replace with Strategory Pattern
    project_id = case params
                 when key?('project') then
                   params[:project]
                 when key?('sprint') then
                   params[:sprint][:project_id]
                 when key?('task') then
                   Sprint.find(params[:task][:sprint_id]).project.id
                 when key?('note')
                   if defined? params[:note][:project_id]
                     params[:note][:project_id]
                   elsif defined? params[:note][:sprint_id]
                     Sprint.find(params[:task][:sprint_id]).project.id
                   end
                 when key?('payment') then
                   params[:payment][:project_id]
                 end

    details = {
        :logger => 'ActionLog',
        :action => rails_action,
        :user_id => current_user.id,
        :params => rails_params,
        :user_agent => request.user_agent
    }

    unless project_id.nil?
      details[:project_id] = project_id
    end

    unless current_user.nil?
      details[:current_user_id] = current_user.id
    end

    unless :ip_address.nil?
      details[:ip_address] = ip_address
    end

    Rails.logger.info MultiJson.dump(details)
  end
end