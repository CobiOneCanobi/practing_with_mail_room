class EmailReceiverWorker
  include Sidekiq::Worker

  def perform(message)
    mail = Mail::Message.new(message)

    puts "New mail from #{mail.from.first}: #{mail.subject}, with attachments #{mail.attachments}, #{mail.has_attachments?}"


    mail.attachments.each do |attch|
      fn = attch.filename
      puts fn
      begin
        File.open( fn, "w+b", 0644 ) { |f| f.write attch.body.decoded }
        rescue Exception => e
        logger.error "Unable to save data for #{fn} because #{e.message}"
      end
    end
  end
end