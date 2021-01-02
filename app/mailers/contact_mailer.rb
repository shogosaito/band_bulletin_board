class ContactMailer < ApplicationMailer
  def contact_mail(contact)
      @contact = contact
      @greeting = "Hi"
      mail(
        subject: "#{@user}様からメッセージが届いています",
        to: "to@example.org"
      )
      binding.pry
  end

  # def contact_mail(contact)
  #   @greeting = "Hi"
  #   mail to: "to@example.org"
  # end
end
