require './functions'
require "io/console"
require 'csv'
class Item_list
    attr_accessor :name, :money_spent, :expected
    def initialize (name,money_spent,expected)
        @name= name
        @money_spent= money_spent
        @expected= expected
    end
end
ar=read_csv("data/budget_copy.csv")
if ar[0].expected==
    create_account(ar,"data/budget_copy.csv")
end
ar=read_csv("data/budget_copy.csv")
menu(ar)
# add_new_item(ar)
# write_csv(ar,"data/budget.csv")
