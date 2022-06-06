require 'net/smtp'
# sollution to send email is inspired by https://mailtrap.io/blog/ruby-send-email/
def send_mail(email)
filename = "chart/line_chart.html"
file_content = File.read(filename)
encoded_content = [file_content].pack("m")  # encode the file
time = Time.new
month=time.strftime("%B")
month.upcase
marker = "AUNIQUEMARKER"
part1 = <<END_OF_MESSAGE
From: Budget saving <hantrangia03@gmail.com>
To: BestUserEver <henrythomasvlluon@gmail.com>
Subject: Summary Of Spending #{month}
MIME-Version: 1.0 
Content-Type: multipart/mixed; boundary = #{marker}
--#{marker}
END_OF_MESSAGE

part2 = <<END_OF_MESSAGE
Content-Type: text/html
Content-Transfer-Encoding:8bit

<h2>Hi this is the summary of your spending this month.</h2>
<p>Please find the attached file.</p>
--#{marker}
END_OF_MESSAGE



part3 = <<END_OF_MESSAGE
Content-Type: multipart/mixed; name = " #{filename}"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename = "#{filename}"

#{encoded_content}
--#{marker}--
END_OF_MESSAGE

message = part1 + part2 + part3 

  Net::SMTP.start('smtp.gmail.com',
    587, # port google mail server
    'smtp.gmail.com',
    'hantrangia03@gmail.com','hungdeptrai', :login) do |smtp|
smtp.send_message message, 'hantrangia03@gmail.com',
  email
end
end