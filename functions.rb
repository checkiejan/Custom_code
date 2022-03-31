require "io/console"
def read_csv(path)
    arr=Array.new()
    t=CSV.read(path)
    for i in t
        u=Item_list.new(i[0],i[1].to_f,i[2].to_f)
        arr<<u
    end
    return arr
end

def read_integer_in_range(prompt, min, max)
    puts  prompt
	value = gets.chomp.to_i
	while (value < min or value > max)
		puts "Please enter a value between " + min.to_s+ " and " + max.to_s + ": "
        puts  prompt
		value = gets.chomp.to_i;
	end
	value
end
def calc_percentage(t)
    arr=Array.new()
    for i in 0..(t.length-1)
        tmp=t[i].money_spent/t[i].expected
        arr<<tmp
    end
    return arr
end
def add_new_item(arr)
    puts "Name the catergory:"
    name=gets.chomp
    puts "Your expected budget: "
    expected=gets.chomp.to_f
    tmp=Item_list.new(name,0.0,expected)
    arr<<tmp
end
def write_csv(arr,path)
    ar=Array.new()
    for i in arr
      tmp=Array.new()
      tmp.append(i.name)
      tmp.append(i.money_spent)
      tmp.append(i.expected)
      ar<<tmp
    end
    File.write(path, ar.map(&:to_csv).join)
end
def go_on
    puts "Press enter to continue"
    gets
end
def ongoing_budget(arr)
    per=calc_percentage(arr)
    index=0
    for x in arr
        puts "#{x.name}:"
        puts "Have spent #{'%.2f' % per[index]}% of your expected(#{x.money_spent} out of #{x.expected})"
        index+=1
    end
    go_on()
end

def update_item(arr)
    count=arr.length
    puts"How much money do you spend this time"
    money=gets.chomp.to_f
    while money<=0
        puts "please enter a positive number"
        money=gets/chomp.to_f
    end
    puts "Choose your category"
    for i in 0..(count-1)
        puts "#{i+1}. #{arr[i].name}"
    end
    choice=read_integer_in_range("Please enter your options in number",1,count)
    arr[choice-1].money_spent+=money
    go_on()
end
def print_menu()
    puts "Welcome back to wallet management"
    puts "1.See ongoing budget"
    puts "2.Update the ongoing budget"
    puts "3.Add new item to the budget"
    n=read_integer_in_range("Please choose your from the above menu:",1,3)
    return n
end
def print_menu_loop()
    puts "1.See ongoing budget"
    puts "2.Update the ongoing budget"
    puts "3.Add new item to the budget"
    puts "4.End task"
    n=read_integer_in_range("Please choose from the menu above:",1,4)
end

def menu(arr)
    n=print_menu()
    cond=true
   while cond ==true
    case n
    when 1
        ongoing_budget(arr)
    when 2
       update_item(arr)
    when 3
        add_new_item(arr)
    when 4
        cond=false
    end
    $stdout.clear_screen()
    if cond==true
        n=print_menu_loop()
    end
    $stdout.clear_screen()
end
end

def setup_initial(id,arr)
    puts "what is your expected budget for #{arr[id-1].name}"
    arr[id-1].expected=gets.chomp.to_f
end
def process_arr(arr)
    tmp=Array.new()
    for i in arr
        if i.expected!=0
            tmp<<i
        end
    end
    return tmp
end
def create_account(arr,path)
    ar=Array.new()
    puts "Welcome to wallet management"
    puts "Belows are several suggestion you can add to your wallet manangement"
    count=arr.length
    for i in 0..(count-1)
        puts "#{i+1}. #{arr[i].name}"
    end
    puts "7. Others"
    choice=read_integer_in_range("Please enter your choice in number",1,count+1)
    cond=true
    while cond == true
        case choice
        when 1..count
            setup_initial(choice,arr)
        when 7
            add_new_item(arr)
        end
        puts "Do you want to continue?(yes/no)"
        x=gets.chomp
        while x!="yes" and x!="no"
            puts "Do you want to continue?(yes/no)"
            x=gets.chomp
        end
        if x =="no" 
            cond=false
        else
            choice=read_integer_in_range("Please enter your choice in number",1,count+1)
        end
    end
   arr=process_arr(arr)
    write_csv(arr,path)
end