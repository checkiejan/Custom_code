require 'csv'
require './graphic.rb'
class Item_list
    attr_accessor :name, :money_spent, :expected
    def initialize (name,money_spent,expected)
        @name= name
        @money_spent= money_spent
        @expected= expected
    end
end

def read_csv(path)
    arr=Array.new()
    t=CSV.read(path)
    for i in t
        u=Button_choice.new
        u.name=i[0]
        u.money_spent=i[1].to_f
        u.expected=i[2].to_f
        arr<<u
    end
    return arr
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
# def get_example
#     return read_csv('data/example.csv')
# end
def check_first
    time=Time.new()
    tmp=read_csv("data/budget#{time.month}.csv")
    if File.file?("data/budget#{time.month-1}.csv")
        return false
    end
    if tmp[0]== nil
        return true
    end
    return false
end
def new_month
    time=Time.new()
    temp=read_csv("data/budget#{time.month-1}.csv")
    ar=Array.new()
    for i in temp
      tmp=Array.new()
      tmp.append(i.name)
      tmp.append(0.0)
      tmp.append(i.expected)
      ar<<tmp
    end
    File.write("data/budget#{time.month}.csv", ar.map(&:to_csv).join)
end
$ar=read_csv('data/example.csv')

AppWindow.new.show()