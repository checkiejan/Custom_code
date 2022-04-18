class Object
    def is_number
      to_f.to_s == to_s || to_i.to_s == to_s
    end
  end
def draw_example
    # @arr=Array.new()
    x= 180
    y= 100
    for i in 0..5
    #   a=Button_choice.new
      $ar[i].x_position=x
      $ar[i].y_position=y
      y+=60
      if i ==2
        x+=200
        y=100
      end
    end
    for id in 0..5
      draw_box( $ar[id].x_position, $ar[id].y_position,100,50)
      draw_text_box( $ar[id].name, $ar[id].x_position, $ar[id].y_position,100,50)
    end
  end
  
  def draw_input
    @button_font.draw('Please enter you budget', 166, 290, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    if (self.text_input.text.is_number or self.text_input.text.length <1)
        @input_font.draw(self.text_input.text,390+center_x(self.text_input.text,@input_font,70), 290, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        @tmp_text=self.text_input.text
    else
        @input_font.draw(@tmp_text,390+center_x( @tmp_text,@input_font,70), 290, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)

    end
   
    draw_box(390,280,70,35)
    draw_box(center_box(100),320,100,50)
    draw_text_box('Submit',center_box(100),320,100,50)
  end
  def draw_bg(choice)
    Gosu.draw_rect($ar[choice].x_position,$ar[choice].y_position,$ar[choice].width,$ar[choice].height, @bg, ZOrder::MIDDLE, mode=:default)
end
  def check_area(mouse_x, mouse_y)
    for i in 0..5
      if $ar[i].check_place(mouse_x, mouse_y)
        choice=i
        return i
      end
    end
    return false
  end
  def check_submit(mouse_x,mouse_y)
    if (mouse_x>270 and mouse_x<270+100) and (mouse_y>320 and mouse_y<370)
        return true
  end
  return false
end
def draw_finish
    draw_box(center_box(100),390,100,50)
    draw_text_box('Finish',center_box(100),390,100,50)
end