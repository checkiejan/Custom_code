require 'gosu'
require 'rubygems'
require './draw_setup'
require './update'
require './draw_sta.rb'
require './chart'
require './send_mail'
require './login.rb'
module ZOrder
    BACKGROUND, LAYER, MIDDLE, TOP = *0..3
end
WIN_WIDTH = 640
WIN_HEIGHT = 640
class Button_exit 
  attr_accessor :width, :height, :x_position, :y_position
  def initialize(x_position,y_position,width,height)
    @x_position=x_position
    @y_position=y_position
    @width=width
    @height=height
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
class Button_choice < Button_exit
  attr_accessor :name,:expected,:money_spent, :history
  def initialize
    @width=100
    @height= 50
    @name
    @expected
    @money_spent
    @history=Array.new()
  end
end

class AppWindow < Gosu::Window
    def initialize(arr)
        super(WIN_WIDTH, WIN_HEIGHT,false)
        self.caption = "Budget Saving"
        @background= Gosu::Color::WHITE
        @bg= 0xff_E4E9BE #color for button update
        @bar=0xff_ffebc1 #color for graph bar
        time=Time.new()
        @screen
        @ar=arr
        if check_first   #check if first time
          month=time.month
          @path="data/budget#{month}.csv"
          @screen= :first_time #set screen to the page used to intialized all the budget
        else #if not screen to strange to home page
          @screen= :login 
          month=time.month
          @path="data/budget#{month}.csv"
          if !File.file?(@path) # check if new month to create a new file for that month
            new_month  #create new file for math including history and budget
            @ar=read_csv(@path)
            write_txt(@ar)
          else
            @ar=read_csv(@path)
            read_txt(@ar)
          end
        end
        @status_submit=false
        @button_expected= Button_exit.new(380-60,290+40,100-10,50) #button to choose what to update- expected
        @button_spent= Button_exit.new(420,290+40,100-10,50) #button to choose what to update- spent
        @button_submit_update=Button_exit.new(5,0,32,32)
        @bg_image=Gosu::Image.new("Brown.png")
        @go_back=Gosu::Image.new("arrow.png")
        @choice_budget #to store what the user choose
        @bg_button=Gosu::Image.new("button.png")
        @bg_button2=Gosu::Image.new("button4.png")
        @ava=Gosu::Image.new("ava.png")
        @button_title = Gosu::Font.new(25)
        @button_font= Gosu::Font.new(20)
        @info_font = Gosu::Font.new(10)
        @example_font= Gosu::Font.new(15)
        @input_font=Gosu::Font.new(16)
        @email_font=Gosu::Font.new(18)
    
        @exit_button=Button_exit.new(5,0,32,32)
        @finish_button= Button_exit.new(center_box(100),390+50,100,50)
        self.text_input= Gosu::TextInput.new
    end
   
    def center_x(text,font,width) #to return the X coordinate when want to align center a text
      return (width-font.text_width(text))/2
    end
    def center_box(width) #return x coordinate when centering a box
      return (WIN_WIDTH-width)/2
    end
    def draw_exit #button exit
      @go_back.draw(5,0,ZOrder::MIDDLE,scale_x=0.5,scale_y=0.5)
    end
    def draw
      draw_bg_image # draw the background
      case @screen
      when :menu
        @ava.draw(center_box(425.6),40,1,scale_x=0.8,scale_y=0.8) # draw the budget saving word
        draw_menu
        
      when :first_time #screen to set up first time
        @ava.draw(center_box(425.6),40,1,scale_x=0.8,scale_y=0.8)
        draw_example
        if validate_budget 
          draw_input 
          draw_bg(@choice_budget) #draw background for the choice
          if check_first == false #check if user has finished at least one option
            draw_finish
          end
        end
      when :update #screen to update
        @ava.draw(center_box(425.6),20,1,scale_x=0.8,scale_y=0.8)
        @button_font.draw("Please choose the category to update", center_x("Please choose the category to update",@button_font,WIN_WIDTH), 75, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
          draw_example
          if validate_budget 
            draw_bg(@choice_budget) #draw background for the choice
            draw_update
            case @choice_update
            when 0
              Gosu.draw_rect(380-60,290+40,100-10,50, @bg, ZOrder::MIDDLE, mode=:default)
              draw_input_update
            when 1
              Gosu.draw_rect(420,290+40,100-10,50, @bg, ZOrder::MIDDLE, mode=:default)
              draw_input_update
            end
           
          end
        draw_exit
      when :show_sta # screen to show bar graph
        draw_exit
        draw_percent
      when :send_mail #screen to send mail
        @ava.draw(center_box(425.6),20,1,scale_x=0.8,scale_y=0.8) # draw the budget saving word
        #@button_title.draw("Welcome to Budget Saving", center_x("Welcome to Budget Saving",@button_title,WIN_WIDTH), 40, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
        draw_mail
        draw_exit
      when :show_history #screen to show history of update
        draw_exit
        draw_history(@choice_budget)
      when :login
        draw_login
      when :setup_login
        draw_setup_login
      end 
    end
    def draw_menu #home page
      @bg_button.draw(center_box(180),130,ZOrder::MIDDLE,scale_x=1.25)
      draw_text_box("Check your budget",center_box(170),130, 180, 60)
      @bg_button.draw(center_box(180),210,ZOrder::MIDDLE,scale_x=1.25)
      draw_text_box("Update your budget",center_box(170),210, 180, 60)
      @bg_button.draw(center_box(180),290,ZOrder::MIDDLE,scale_x=1.25)
      draw_text_box("Send email",center_box(180),290, 180, 60)
    end
    def draw_box(left,top,width,height)
        Gosu.draw_rect(left,top,width,height, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default)
        Gosu.draw_rect(left-2,top-2,width+4,height+4, Gosu::Color::BLACK, ZOrder::LAYER, mode=:default)
    end
   
    def draw_text_box(text,left,top,width,height)  #to draw text align center inside a box
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
      case @screen
      when :first_time
        if validate_budget 
          if is_number(self.text_input.text) #check if user input a number
            @ar[@choice_budget].expected=self.text_input.text.to_f
          end
        end
      when :send_mail
        
          if is_email_valid? self.text_input.text and @status_submit #check email valid, text no null and submit, if true then send the email
           create_chart
           send_mail(self.text_input.text)
          end
          @status_submit=false
        when :update
          if @status_submit
            case @choice_update
            when 0 #update expected
              if is_number(self.text_input.text)
               @ar[@choice_budget].expected=self.text_input.text.to_f
               puts @ar[@choice_budget].expected
               puts @ar[@choice_budget].money_spent
                write_csv(@ar,@path)
                @status_submit=false
              end
            when 1 #update spent
              if is_number(self.text_input.text)
               @ar[@choice_budget].money_spent +=self.text_input.text.to_f
               puts @ar[@choice_budget].expected
               puts @ar[@choice_budget].money_spent
                write_csv(@ar,@path)
                time=Time.new()
                string=time.strftime("%d/%m/%Y - %I:%M %p")
                tmp_item=Item_history.new(string,self.text_input.text.to_f)
                @ar[@choice_budget].history.append(tmp_item)
                write_txt(@ar)
                @status_submit=false
              end
            end
          end
      end
    end

    def mouse_over_button(mouse_x, mouse_y)
        if ((mouse_x > center_box(180) and mouse_x < center_box(180)+180) and (mouse_y > 130 and mouse_y < 130+60))
          return 1
        elsif ((mouse_x > center_box(180) and mouse_x < center_box(180)+180) and (mouse_y > 210 and mouse_y < 210+60))
          return 2
        elsif ((mouse_x > center_box(180) and mouse_x < center_box(180)+180) and (mouse_y > 290 and mouse_y < 290+60))
            return 3
        end
    end
      
    def button_down(id)
        case id
        when 40 # id for enter button
          case @screen
          when :login
            if check_pwd(self.text_input.text) # check if correct password
              @screen= :menu
              self.text_input.text=""
            end
          end
        when Gosu::MsLeft
          case @screen
          when :menu
            navigate_menu=  mouse_over_button(mouse_x, mouse_y) #return choice from user
           case navigate_menu
           when 1
            @screen= :show_sta
           when 2
           @screen = :update
           self.text_input.text="" # reset the word input
           when 3
            @screen = :send_mail
           end

          when :first_time
            if check_area(mouse_x, mouse_y)!=nil and check_area(mouse_x, mouse_y) != false
              @choice_budget=check_area(mouse_x, mouse_y)
              puts @choice_budget
            end
            if validate_budget and check_submit(mouse_x,mouse_y)
              write_csv(@ar,@path)
            end
            if check_first == false and @finish_button.check_place(mouse_x,mouse_y)
              self.text_input.text=nil
              @screen= :setup_login
            end
          when :update
            if check_area(mouse_x, mouse_y)!=nil and check_area(mouse_x, mouse_y) != false
              @choice_budget=check_area(mouse_x, mouse_y)
              puts @choice_budget
            end
            if @exit_button.check_place(mouse_x,mouse_y)       
              self.text_input.text=nil
              @choice_budget=nil
              @choice_update=nil
              @screen = :menu
            end
            if validate_budget
              if @button_expected.check_place(mouse_x,mouse_y)
                @choice_update=0
  
              elsif @button_spent.check_place(mouse_x,mouse_y)
                  @choice_update=1
               
              end
            end
            if check_submit_update(mouse_x,mouse_y) 
              @status_submit=true
            end
          when :show_sta
            if @exit_button.check_place(mouse_x,mouse_y)                    
                   self.text_input.text=nil
                   @screen = :menu
            end
            if check_area_history != nil
              @choice_budget=check_area_history
              @screen= :show_history
            end
          when :send_mail
            if @exit_button.check_place(mouse_x,mouse_y)         
              self.text_input.text=nil
              @screen = :menu
            end
            if check_submit_mail(mouse_x,mouse_y) 
                      @status_submit=true
                      puts @status_submit
                    end
          when :show_history
            if @exit_button.check_place(mouse_x,mouse_y)         
              self.text_input.text=nil
              @screen = :show_sta
              @choice_budget=nil
            end
          when :login
            if check_submit_mail(mouse_x,mouse_y)
              if check_pwd(self.text_input.text)
                @screen= :menu
                self.text_input.text=""
              end
            end
          when :setup_login
            if check_submit_mail(mouse_x,mouse_y) 
              if self.text_input.text != ""
                encrypte_pwd(self.text_input.text)
                @screen = :menu
              end
            end
          end
      end
    end
end


