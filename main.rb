require 'csv'
require './graphic.rb'
class Item_history
    attr_accessor :time_trans, :amount
    def initialize (time,amount)
        @time_trans=time #time of the update
        @amount=amount  #amount of the updateadmi
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
def read_txt(arr)
    time=Time.new()
    a_file=File.new("data/history#{time.month}.txt",'r')
    for i in 0..5
        count=a_file.gets.to_i
        for j in 0..(count-1)
            tmp_item=Item_history.new(a_file.gets,a_file.gets.to_f) # store the history for that category
            arr[i].history << tmp_item
        end
    end
end
def write_txt(arr)
    time=Time.new()
    a_file=File.new("data/history#{time.month}.txt",'w')
    for i in 0..5
        count=arr[i].history.length
        a_file.puts(count)
        if count >0
        for j in 0..(count-1)
            a_file.puts(arr[i].history[j].time_trans)
            a_file.puts(arr[i].history[j].amount)
        end
    end
    end
    a_file.close()
    
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

def check_first
    time=Time.new()
    if File.file?("data/budget#{time.month-1}.csv") or File.file?("data/budget#{time.month}.csv") # check the existence of last month and this month file
        return false
    end
    return true
end
def new_month
    time=Time.new()
    temp=read_csv("data/budget#{time.month-1}.csv") # create new file for new month
    ar=Array.new()
    for i in temp # take the expected money of last month and put that in the new month, set all spent money to 0
      tmp=Array.new()
      tmp.append(i.name)
      tmp.append(0.0)
      tmp.append(i.expected)
      ar<<tmp
    end
    File.write("data/budget#{time.month}.csv", ar.map(&:to_csv).join)
end
def main
    ar=read_csv('data/example.csv')

    app=AppWindow.new(ar)
    app.show()
end
main
