class EmailReceiverWorker
  include Sidekiq::Worker
  def perform(message)
    mail = Mail::Message.new(message)
      if mail.encrypted?
        # decrypt using your private key, protected by the given passphrase
        plaintext_mail = mail.decrypt(:password => ENV["pgp_password"])
        puts plaintext_mail.body
        # the plaintext_mail, is a full Mail::Message object, just decrypted
      end
    puts "New mail from #{mail.from.first}: #{mail.subject}, with attachments #{mail.has_attachments?}"

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
