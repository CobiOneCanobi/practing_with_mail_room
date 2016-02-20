class EmailReceiverWorker
  include Sidekiq::Worker

  def perform(message)
    mail = Mail::Message.new(message)

    puts "New mail from #{mail.from.first}: #{mail.subject}, with attachments #{mail.attachments}, #{mail.attachment?}"
  end
end