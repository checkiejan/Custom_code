def draw_percent
    sum_expt=0
    sum_sp=0
    y=60
    $ar.each do |n|
        draw_box(130,y+20,350,40)
        if n.money_spent>n.expected
        @input_font.draw("#{n.name}: #{'%.1f' % n.money_spent}$ out of #{'%.1f' % n.expected}$(TOO MUCH!) ", 130, y, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        Gosu.draw_rect(130,y+20,350,40, 0xff_b20600, ZOrder::TOP, mode=:default)
        else
        @input_font.draw("#{n.name}: #{'%.1f' % n.money_spent}$ out of #{'%.1f' % n.expected}$ ", 130, y, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        Gosu.draw_rect(130,y+20,350*(n.money_spent/n.expected),40, @bar, ZOrder::TOP, mode=:default)
        end
        y+=70
        sum_expt+=n.expected
        sum_sp+=n.money_spent
    end
    @button_font.draw("You spent #{'%.1f' % sum_sp}$ out of #{'%.1f' % sum_expt}$ for this month", center_x("You spent #{'%.1f' % sum_sp}$ out of #{'%.1f' % sum_expt}$ for this month",@button_font,WIN_WIDTH), 10, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
end
def draw_mail
    @button_font.draw("Please enter your mail to receive the report of this month spending",center_x('Please enter your mail to receive the report of this month spending',@button_font,WIN_WIDTH), 80, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    draw_box(center_box(250),120,250,40)
    @email_font.draw(self.text_input.text,center_box(250)+center_x(self.text_input.text, @email_font,250), 130, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
   draw_box(center_box(100),180,100,50)
    draw_text_box('Send mail',center_box(100),180,100,50)
end
def check_submit_mail(mouse_x,mouse_y)
    return ((mouse_x>center_box(100) and mouse_x<center_box(100)+100) and (mouse_y>180 and mouse_y<180+50))
end
# REGEX_PATTERN = /^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$/
# def is_email_valid? email
#     email =~REGEX_PATTERN
# end
REGEX_PATTERN = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/
def is_email_valid? email
    email =~REGEX_PATTERN
end
