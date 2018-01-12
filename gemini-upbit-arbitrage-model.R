# This script retreives spot pricing for KRW per ether from Gemini (US) and Upbit (KO) exchanges.
# NOTE: The KRWUSD spread is provided by Fixer.io.
# AUTHOR: Munair Simpson
# ORGANIZATION: Useful Coin LLC
# LICENSE: MIT
#
# Install the curl and jsonlite packages in order to work with JSON data.
# Include the JSON Lite Library to interface with the APIs.
# RUNONCE: install.packages("jsonlite")
# RUNONCE: install.packages("curl")
library(curl)
library(jsonlite)

# Get the latest pricing information using public APIs
upbitjsondata <- fromJSON("https://crix-api-endpoint.upbit.com/v1/crix/candles/lines?code=CRIX.UPBIT.KRW-ETH&count=1")
geminijsondata <- fromJSON("https://api.gemini.com/v1/pubticker/ethusd")
fixerjsondata <- fromJSON("https://api.fixer.io/latest?base=USD&symbols=KRW")

# Visually verify the Upbit and Gemini data received.
str(upbitjsondata)
str(geminijsondata)
str(fixerjsondata)

# Format the required pricing data as numeric.
ask <- as.numeric(upbitjsondata$candles$tradePrice[1])
bid <- as.numeric(geminijsondata$bid) * fixerjsondata$rates$KRW
spread <- ask - bid
halfsplit <- spread / 2
offer <- bid + halfsplit
grossmarginratio <- halfsplit / offer

# Create dataframe of simple model
simplemodel <- data.frame(ask =  format(ask, scientific=FALSE, big.mark=","),
                          bid =  format(bid, scientific=FALSE, big.mark=","),
                          spread =  format(spread, scientific=FALSE, big.mark=","),
                          grossrevenue = format(offer, scientific=FALSE, big.mark=","),
                          directcost = format(bid, scientific=FALSE, big.mark=","),
                          grossmargin = format(halfsplit, scientific=FALSE, big.mark=","),
                          grossmarginratio = sprintf("%.2f%%",100*grossmarginratio)
)

# View dataframe
View(simplemodel)

# TODO: Make a model that includes VAT and Income Tax if this arbitrage opportunity lasts more than a month.