try:
    import plotly.graph_objects as grob
    import yfinance
except ModuleNotFoundError:
    import os
    os.system("pip install plotly")
    os.system("pip install yfinance")

stock = yfinance.Ticker('MSFT')
past = stock.history(period = '1y')

plot = grob.Figure(data = grob.Scatter(x=past.index,y=past['Close'], mode='lines'))
plot.show()