class TestMailer < ApplicationMailer
  def send_mail
    mail_info = {
      to: 'recipient@test.com',
      from: 'sender@test.com',
      from_display_name: 'バンド募集掲示板',
      subject: 'テスト太郎様からメッセージが届いています。',
      body: '本メールはテスト太郎様からのテストメールです。',
    }

    from = Mail::Address.new mail_info[:from]
    from.display_name = mail_info[:from_display_name]

    mail(subject: mail_info[:subject], from: from.format, to: mail_info[:to]) do |format|
      format.text { render plain: mail_info[:body] }
    end
  end
end
