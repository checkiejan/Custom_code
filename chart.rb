require 'rbplotly'
require 'daru'
def create_chart
  time=Time.new()
  #read in file of the recent month
  data=CSV.read("data/budget#{time.month}.csv")
  index=Array.new()
  money_spent=Array.new()
  expected=Array.new()
  #separate money spent and expected
  data.each do |n|
    index << n[0]
    money_spent <<n[1].to_f
    expected << n[2].to_f
  end
  index << "Total"
  money_spent << money_spent.sum
  expected << expected.sum
  # use daru to store data as a dictionary
  data_frame = Daru::DataFrame.new(
          {
            'Spent' => money_spent,
            'Expected' => expected
          },
          index: index
        )
  #data for the first bar
  trace1 = {
          x:    index,
          y:   money_spent,
          type: :bar,
          name: 'Spent'
  }
  #data for the second bar
  trace2 = {
          x:    index,
          y:    expected,
          type: :bar,
          name: 'Expected'
  }
  time = Time.new
  month=time.strftime("%B")
  month.upcase

  layout = { title: "Summary spending of #{month}" } #title for the figure
  plot = Plotly::Plot.new(data: [trace1, trace2],layout: layout) #use Plotty to draw
  Plotly.auth('hung123', 'FWxUPwNxvCFkpTyE4Kzu') #username and key to download figure
  plot.generate_html(path: './chart/line_chart.html') #generate html file
  # plot.download_image(path: 'chart/line_chart.jpg') #generate image file
end