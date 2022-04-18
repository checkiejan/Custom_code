require 'rbplotly'
require 'daru'
def create_chart
  time=Time.new()
  t=CSV.read("data/budget#{time.month}.csv")
  index=Array.new()
  money_spent=Array.new()
  expected=Array.new()
  t.each do |n|
    index << n[0]
    money_spent <<n[1].to_f
    expected << n[2].to_f
  end
  index << "Total"
  money_spent << money_spent.sum
  expected << expected.sum
  data_frame = Daru::DataFrame.new(
          {
            'Spent' => money_spent,
            'Expected' => expected
          },
          index: index
        )
  trace1 = {
          x:    index,
          y:   money_spent,
          type: :bar,
          name: 'Spent'
  }
  trace2 = {
          x:    index,
          y:    expected,
          type: :bar,
          name: 'Expected'
  }
  layout = { title: 'Summary spending of this month' }
  plot = Plotly::Plot.new(data: [trace1, trace2],layout: layout)
  Plotly.auth('hung123', 'FWxUPwNxvCFkpTyE4Kzu')
  plot.generate_html(path: './chart/line_chart.html')
  # plot.download_image(path: 'chart/line_chart.jpg')
end