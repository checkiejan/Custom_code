require 'bcrypt'
def encrypte_pwd(pwd)
    salt="asdhjsad23199090!@#@!#"
    my_password = BCrypt::Password.create(salt+pwd)
    a_file=File.new("data/pwd.txt",'w')
    a_file.puts(my_password)
    a_file.close()
end
def check_pwd(pwd)
    salt="asdhjsad23199090!@#@!#"
    a_file=File.new("data/pwd.txt",'r')
    tmp=a_file.gets.chomp
    a_file.close
    tmp=BCrypt::Password.new(tmp)
    return tmp==(salt+pwd)
end

def draw_login
    @ava.draw(center_box(425.6),20,1,scale_x=0.8,scale_y=0.8)
    @button_font.draw("Please enter your password",center_x("Please enter your password",@button_font,WIN_WIDTH),80, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    draw_box(center_box(250),120,250,40)
    @email_font.draw(self.text_input.text,center_box(250)+center_x(self.text_input.text, @email_font,250), 130, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
   @bg_button.draw(center_box(150),180,ZOrder::MIDDLE)
    draw_text_box('Login',center_box(150),180,150,60)
end
def draw_setup_login
    @button_title.draw("Please setup your password",center_x("Please setup your password",@button_title,WIN_WIDTH),40, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    draw_box(center_box(250),120,250,40)
    @email_font.draw(self.text_input.text,center_box(250)+center_x(self.text_input.text, @email_font,250), 130, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    @bg_button.draw(center_box(150),180,ZOrder::MIDDLE)
    draw_text_box('Login',center_box(150),180,150,60)
end