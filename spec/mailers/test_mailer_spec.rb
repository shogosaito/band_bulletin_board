require 'rails_helper'

RSpec.describe TestMailer, type: :mailer do
  before do
    ActionMailer::Base.deliveries.clear
  end

  describe '#send_mail' do
    subject(:mail) do
      described_class.send_mail.deliver_now
      ActionMailer::Base.deliveries.last
    end

    context 'when send_mail' do
      it { expect(mail.from.first).to eq('sender@test.com') }
      it { expect(mail.to.first).to eq('recipient@test.com') }
      it { expect(mail.subject).to eq('テスト太郎様からメッセージが届いています。') }
      it { expect(mail.body).to match('本メールはテスト太郎様からのテストメールです。') }
    end
  end
end
