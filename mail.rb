require 'mail'
Mail.defaults do
    delivery_method :smtp, { :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'hantrangia03@gmail.com',
      :user_name            => 'vl',
      :password             => 'hungdeptrai',
      :authentication       => 'plain',
      :enable_starttls_auto => true  }
    end
    mail = Mail.new do
        from    'hantrangia03@gmail.com'
        to      'henrythomasvlluon@gmail.com'
        subject 'Email with HTML and an attachment'
      
        text_part do
          body 'Put your plain text here'
        end
      
        add_file 'line_chart.png'
      end
   