require 'gosu'
require 'rubygems'
require './draw_setup'
require './update'
require './draw_sta.rb'
require './chart'
require './send_mail'
# require './main'
module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end
WIN_WIDTH = 640
WIN_HEIGHT = 500
class Button_choice
  attr_accessor :width, :height, :x_position, :y_position,:name,:expected,:money_spent
  def initialize
    @width=100
    @height= 50
    @x_position
    @y_position
    @name
    @expected
    @money_spent
  end
  def check_place(x,y)
    if x!= nil and y!=nil
      if (x>= @x_position and x<=@x_position+ @width) and (y>= @y_position and y<=@y_position+ @height) 
        return true
      else
        return false
      end
    end
  end
end
class Button_exit < Button_choice
  def initialize(x_position,y_position,width,height)
    @x_position=x_position
    @y_position=y_position
    @width=width
    @height=height
  end
end
class AppWindow < Gosu::Window
    def initialize
        super(WIN_WIDTH, WIN_HEIGHT,false)
        self.caption = "Budget Saving"
        @background= Gosu::Color::WHITE
        @bg= 0xff_E4E9BE
        @bar=0xff_ffebc1
        @first_time
        @menu=true
        @check_budget=false
        time=Time.new()
        if check_first
          @first_time=true
          @menu=false
          month=time.month
          @path="data/budget#{month}.csv"
        else
          @first_time=false
          month=time.month
          if File.file?("data/budget#{month-1}.csv") and File.file?("data/budget#{month}.csv")!=true
            new_month
          end
          @path="data/budget#{month}.csv"
          $ar=read_csv(@path)
          puts $ar[0].money_spent
        end
        @status_submit=false
        @button_expected= Button_exit.new(380-60,290,100-10,50)
        @button_spent= Button_exit.new(420,290,100-10,50)
        @choice_update
        @button_submit_update=Button_exit.new(5,0,32,32)
        @exit=false
        @go_back=Gosu::Image.new("arrow.png")
        @choice_budget
        @choosing= false
        @button_title = Gosu::Font.new(25)
        @button_font= Gosu::Font.new(20)
        @info_font = Gosu::Font.new(10)
        @example_font= Gosu::Font.new(15)
        @input_font=Gosu::Font.new(16)
        @email_font=Gosu::Font.new(18)
        @arr
        @exit_button=Button_exit.new(5,0,32,32)
        @chosen=false
        @tmp_txt
        @finish_button= Button_exit.new(center_box(100),390,100,50)
        @navigate_menu
        self.text_input= Gosu::TextInput.new
        @send_mail=false
        @mail
    end
   
    def center_x(text,font,width)
      return (width-font.text_width(text))/2
    end
    def center_box(width)
      return (WIN_WIDTH-width)/2
    end
    def draw_exit
      @go_back.draw(5,0,ZOrder::MIDDLE,scale_x=0.5,scale_y=0.5)
    end
    def draw
        Gosu.draw_rect(0, 0,WIN_WIDTH, WIN_HEIGHT, @background, ZOrder::BACKGROUND, mode=:default)
        if !@check_budget
        @button_title.draw("Welcome to Budget Saving", center_x("Welcome to Budget Saving",@button_title,WIN_WIDTH), 40, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        end
        # Gosu.draw_rect(220, 80, 150, 50, Gosu::Color::GREEN, ZOrder::MIDDLE, mode=:default)
        if @menu
          draw_menu
        end
        if @send_mail
          draw_mail
          draw_exit
        end
        if @check_budget
          draw_exit
          draw_percent
        end
        if @first_time ==true
          # @example_font.draw("Please add your expected limit to each category", center_x("Please add your expected limit to each category",@example_font,WIN_WIDTH), 70, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
          # Gosu.draw_rect(0, 0,WIN_WIDTH, WIN_HEIGHT, @background, ZOrder::BACKGROUND, mode=:default)
          @choosing=true
          draw_example
          if validate_budget #or @chosen
            draw_input
            draw_bg(@choice_budget)
            if check_first == false
              draw_finish
            end
          end
        end
        if @choosing and !@first_time and !@menu
          @example_font.draw("Please choose the category to update", center_x("Please choose the category to update",@example_font,WIN_WIDTH), 70, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
          draw_example
          if validate_budget 
            draw_bg(@choice_budget)
            draw_update
            case @choice_update
            when 0
              Gosu.draw_rect(380-60,290,100-10,50, @bg, ZOrder::MIDDLE, mode=:default)
              draw_input_update
            when 1
              Gosu.draw_rect(420,290,100-10,50, @bg, ZOrder::MIDDLE, mode=:default)
              draw_input_update
            end
          end
          draw_exit
        end
    end
    def draw_menu
      draw_box(center_box(170), 90, 170, 50)
      draw_text_box("Check your budget",center_box(170), 90, 170, 50)
      draw_box(center_box(170), 150, 170, 50)
      draw_text_box("Update your budget",center_box(170), 150, 170, 50)
      draw_box(center_box(170), 210, 170, 50)
      draw_text_box("Send email",center_box(170), 210, 170, 50)
    end
    def draw_box(left,top,width,height)
        Gosu.draw_rect(left,top,width,height, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default)
        Gosu.draw_rect(left-2,top-2,width+4,height+4, Gosu::Color::BLACK, ZOrder::BACKGROUND, mode=:default)
    end
   
    def draw_text_box(text,left,top,width,height)
        length_text= @button_font.text_width(text)
        height_text=@button_font.height()
        y=(height-height_text)/2
        x=(width-length_text)/2
        ar=Array.new()
        ar << (left+x)
        ar<< (top+y)
        @button_font.draw(text, ar[0], ar[1], ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    end
    def update
      if @choosing and validate_budget and @first_time
        # @chosen=true
        if self.text_input.text.is_number
          $ar[@choice_budget].expected=self.text_input.text.to_f
          # puts  $ar[@choice_budget].expected
        end
      end
      if @choosing == false
        case @navigate_menu
        when 1
        when 2
          @choosing=true
        end
      end
      if @send_mail and @status_submit and !@choosing and !@menu and !@first_time
         if is_email_valid? self.text_input.text
          @mail=self.text_input.text
          puts @mail
          create_chart
          send_mail(self.text_input.text)
         end
         @status_submit=false
      end
      if @choosing and !@first_time and validate_budget and @status_submit
        case @choice_update
        when 0
          puts "hkshds"
          if  self.text_input.text.is_number 
           $ar[@choice_budget].expected=self.text_input.text.to_f

           
           puts "dsadsa"
           puts $ar[@choice_budget].expected
           puts $ar[@choice_budget].money_spent
            write_csv($ar,@path)
            @status_submit=false
          end
        when 1
          if  self.text_input.text.is_number 
           $ar[@choice_budget].money_spent +=self.text_input.text.to_f
           puts "asdsdffffffff"
           puts $ar[@choice_budget].expected
           puts $ar[@choice_budget].money_spent
            write_csv($ar,@path)
            @status_submit=false
          end
        end
      end
    end
    def needs_cursor?; true; end
    def mouse_over_button(mouse_x, mouse_y)
        if ((mouse_x > center_box(170) and mouse_x < center_box(170)+170) and (mouse_y > 90 and mouse_y < 90+50))
          return 1
        elsif ((mouse_x > center_box(170) and mouse_x < center_box(170)+170) and (mouse_y > 150 and mouse_y < 150+50))
          return 2
        elsif ((mouse_x > center_box(170) and mouse_x < center_box(170)+170) and (mouse_y > 210 and mouse_y < 210+50))
            return 3
        end
    end
      
    def button_down(id)
        case id
        when Gosu::MsLeft
         
          if @choosing and !@menu
            if check_area(mouse_x, mouse_y)!=nil and check_area(mouse_x, mouse_y) != false
              @choice_budget=check_area(mouse_x, mouse_y)
              puts @choice_budget
            end
            if @first_time
                  if validate_budget and check_submit(mouse_x,mouse_y)
                    # AR[@choice_budget].expected = @arr[@choice_budget].expected
                    write_csv($ar,@path)
                    puts "vlluon"
                  end
                  if check_first == false and @finish_button.check_place(mouse_x,mouse_y)
                    @first_time=false
                    puts "haha"
                    @choosing=false
                    @menu=true
                  end
            elsif !@first_time
                    if @exit_button.check_place(mouse_x,mouse_y) and check_first !=true
                     @menu=true
                     @choosing=false
                     @choice_budget=false
                     @choice_update=nil
                     @status_submit=false
                    self.text_input.text=nil
                    end
                    if @choice_budget!=false and @choice_budget!=nil
                      if @button_expected.check_place(mouse_x,mouse_y)
                        @choice_update=0
          
                      elsif @button_spent.check_place(mouse_x,mouse_y)
                          @choice_update=1
                         
                      end
                    end
                    if check_submit_update(mouse_x,mouse_y) 
                      @status_submit=true
                    end
            end
          elsif @menu and @first_time!= true
           @navigate_menu=  mouse_over_button(mouse_x, mouse_y)
           case @navigate_menu
           when 1
            @menu=false
            @check_budget=true
            puts @check_budget
            @choosing=false
           when 2
           @menu=false
           @choosing=true
           when 3
            @send_mail=true
            @menu=false
            @choosing=false
            @check_budget=false
           end
           elsif @check_budget and !@menu and !@choosing
            if @exit_button.check_place(mouse_x,mouse_y) 
              @menu=true
              @choosing=false
              @choice_budget=false
             self.text_input.text=nil
             @check_budget=false
             end
             elsif @send_mail and !@check_budget and !@choosing and !@menu
              if @exit_button.check_place(mouse_x,mouse_y) 
                @menu=true
                @choosing=false
                @choice_budget=false
               self.text_input.text=nil
               @check_budget=false
               @send_mail=false
              #  @status_submit=false
               end
               if check_submit_mail(mouse_x,mouse_y) 
                @status_submit=true
                puts @status_submit
              end
         end
        end
      end
end

# AppWindow.new.show()
