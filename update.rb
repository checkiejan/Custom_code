def draw_update
    @button_font.draw('Choose what to update', 166-50, 300+40, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    draw_box(380-60,290+40,100-10,50)
    draw_text_box('Expected',380-60,290+40,100-10,50)
    draw_box(420,290+40,100-10,50)
    draw_text_box('Spent',420,290+40,100-10,50)
end
def draw_input_update
    @button_font.draw('Please enter your update', 166-50, 380+40, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    draw_box(340,370+40,100-10,40)
    if (is_number(self.text_input.text) or self.text_input.text.length <1)
        @input_font.draw(self.text_input.text,340+center_x(self.text_input.text,@input_font,90), 380+40, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        @tmp_text=self.text_input.text
    else
        @input_font.draw(@tmp_text,340+center_x( @tmp_text,@input_font,90), 380+40, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        self.text_input.text=self.text_input.text[0..-2] # if input wrong delete that character
    end
    if self.text_input.text != nil
        draw_box(center_box(90),420+40,100-10,40)
        draw_text_box('Submit',center_box(90),420+40,100-10,40)
    end
end
def check_submit_update(mouse_x,mouse_y) #check if clicked submit button
    if (mouse_x>center_box(90) and mouse_x<center_box(90)+100-10) and (mouse_y>420+40 and mouse_y<420+40+40)
        return true
  end
  return false
end
def validate_budget # check if the user has choosed any button
    if @choice_budget!=false and @choice_budget!=nil
        return true
    end
    return false
end
