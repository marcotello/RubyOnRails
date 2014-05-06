class ErrorNotifier < ActionMailer::Base
  default from: 'Depot Application <depot@example.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_notifier.raised.subject
  #
  def raised(error, controller_name, action_name)
    @error = error
    @controller_name = controller_name 
    @action_name = action_name

    mail to: 'marcotello@grupovidanta.com', subject: 'Pragmatic Store Error Raised'
  end
end
