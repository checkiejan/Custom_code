  def is_number(x) # check if input is a number
    if x.to_f.to_s == x.to_s || x.to_i.to_s == x.to_s
      return true
    end
    if x[-1]=="."
      if x[0..-2].to_f.to_s == x[0..-2].to_s || x[0..-2].to_i.to_s == x[0..-2].to_s # check if the user input  . as float number
        return true
      end
    end
  end
  def draw_example  #draw all the selection for user
    x= 180
    y= 120
    for i in 0..5
      @ar[i].x_position=x #set x position for the box
      @ar[i].y_position=y #set y position for the box
      y+=75
      if i ==2
        x+=200
        y=120
      end
    end
    for id in 0..5
      draw_box( @ar[id].x_position, @ar[id].y_position,100,50)
      draw_text_box( @ar[id].name, @ar[id].x_position, @ar[id].y_position,100,50)
    end
  end
  
  def draw_input
    @button_font.draw('Please enter you budget', 166, 290+50, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    if (is_number(self.text_input.text) or self.text_input.text.length <1) #check valid input
        @input_font.draw(self.text_input.text,390+center_x(self.text_input.text,@input_font,70), 290+60, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    else #if not no draw
        self.text_input.text=self.text_input.text[0..-2] # if input wrong delete that character
        @input_font.draw(self.text_input.text,390+center_x(self.text_input.text,@input_font,70), 290+60, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    end
   
    draw_box(390,290+50,70,35)
    draw_box(center_box(100),320+60,100,50) #draw box for submit
    draw_text_box('Submit',center_box(100),320+60,100,50)
  end

  def draw_bg(choice)
    Gosu.draw_rect(@ar[choice].x_position,@ar[choice].y_position,@ar[choice].width,@ar[choice].height, @bg, ZOrder::MIDDLE, mode=:default)
  end

  def check_area(mouse_x, mouse_y) #check which box user choose
    for i in 0..5
      if @ar[i].check_place(mouse_x, mouse_y)
        choice=i
        return i
      end
    end
    return false
  end
  
  def check_submit(mouse_x,mouse_y) #check if user click submit button
    if (mouse_x>270 and mouse_x<270+100) and (mouse_y>320+60 and mouse_y<370+60)
        return true
    end
    return false
  end

  def draw_finish #finish box
      draw_box(center_box(100),390+50,100,50)
      draw_text_box('Finish',center_box(100),390+50,100,50)
  end
def draw_bg_image
  x=0
  y=0
  for i in 0..9
    for j in 0..9
      @bg_image.draw(x,y, ZOrder::BACKGROUND)
      x+=64
    end
    x=0
    y+=64
  end
end