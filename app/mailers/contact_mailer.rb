class ContactMailer < ApplicationMailer
  def contact_mail(contact, user)
    @contact = contact
    @greeting = "Hi"
    mail(
      subject: "#{user.user_name}様からメッセージが届いています",
      to: $post_user.email
    )
  end

  # def contact_mail(contact)
  #   @greeting = "Hi"
  #   mail to: "to@example.org"
  # end
end
