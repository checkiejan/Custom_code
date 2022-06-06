def draw_percent #draw bar graph to visualize
    sum_expt=0
    sum_sp=0
    y=85
    @ar.each do |n|
        draw_box(130,y+20,350,40)
        if n.money_spent>n.expected #if spent too much draw red
        @input_font.draw("#{n.name}: $#{'%.1f' % n.money_spent} out of $#{'%.1f' % n.expected}$(TOO MUCH!) ", 130, y, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        Gosu.draw_rect(130,y+20,350,40, 0xff_b20600, ZOrder::TOP, mode=:default)
        else #draw normal color
        @input_font.draw("#{n.name}: $#{'%.1f' % n.money_spent} out of $#{'%.1f' % n.expected} ", 130, y, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        Gosu.draw_rect(130,y+20,350*(n.money_spent/n.expected),40, @bar, ZOrder::TOP, mode=:default)
        end
        y+=90
        sum_expt+=n.expected #total expected
        sum_sp+=n.money_spent #calculate the total spent
    end
    @button_font.draw("You spent $#{'%.1f' % sum_sp} out of $#{'%.1f' % sum_expt} for this month", center_x("You spent #{'%.1f' % sum_sp}$ out of #{'%.1f' % sum_expt}$ for this month",@button_font,WIN_WIDTH), 40, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    @button_title.draw( "$#{'%.1f' % (sum_expt-sum_sp)} left",center_x("$#{'%.1f' % (sum_expt-sum_sp)} left",  @button_title,WIN_WIDTH),7,ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    draw_hover_bar
end

def check_area_history #check if user click any bar to see history of update
    x=130
    y=85
   for i in 0..5
    if mouse_x>= x and mouse_x <=x+350 and mouse_y >=y+20 and mouse_y <= y+60
        return i
    end
    y+=90
   end
   return nil
end
def draw_hover_bar
    if check_area_history !=nil
        x=130
        y= 85 + 90*check_area_history
        Gosu.draw_rect(x-4,y+16,350+8,60-12, 0xff_16003B, ZOrder::LAYER, mode=:default)
    end
end
def draw_mail
    @button_font.draw("Please enter your mail to receive the report of this month spending",center_x('Please enter your mail to receive the report of this month spending',@button_font,WIN_WIDTH), 80, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    draw_box(center_box(250),120,250,40)
    @email_font.draw(self.text_input.text,center_box(250)+center_x(self.text_input.text, @email_font,250), 130, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    @bg_button.draw(center_box(150),180,ZOrder::MIDDLE)
    draw_text_box('Send mail',center_box(150),180,150,60)
end

def check_submit_mail(mouse_x,mouse_y) #check if user click submit mail
    return ((mouse_x>center_box(150) and mouse_x<center_box(150)+150) and (mouse_y>180 and mouse_y<180+60))
end

REGEX_PATTERN = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/
def is_email_valid? email #check email valid with regex
    email =~REGEX_PATTERN
end
def draw_history(id) # draw the history of update page
    @ar[id].name
    @button_title.draw(@ar[id].name,center_x(@ar[id].name,@button_title,WIN_WIDTH),10, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    @button_font.draw("History of update",60, 50,ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    @button_title.draw("$",WIN_WIDTH-75, 50,ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    draw_line(40, 75, Gosu::Color::BLACK, WIN_WIDTH-40, 75, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    count=@ar[id].history.length
    x= 50
    y=90
    for i in 0..(count-1)
        @email_font.draw(@ar[id].history[i].time_trans,x,y,ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        @email_font.draw(@ar[id].history[i].amount,  WIN_WIDTH-80, y,ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK  )
        draw_line(40, y+30, Gosu::Color::BLACK, WIN_WIDTH-40, y+30, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
        y+=40
    end
end