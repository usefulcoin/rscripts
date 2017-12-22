# R Script used to examine data from http://www.coinmarketcap.com for a Coin Telegraph Article
#
# NOTE: The dataset was compiled on December 10th 2017. It was a merge of the top 1000 coins and exchange listings.
# The merge was done using Google Sheets. The exchange listings were compiled with BASH.
#
#
# DATASET: Read in CSV datafile from Useful Coin Repository.
# WARNING: Using the dataset that contains market capitalization data and exchange listings PER cryptocurrency.
# USAGE: Use the first line of the file for column headings.
exchangelistings = read.csv("https://s3.ap-northeast-2.amazonaws.com/usefulcoin/coinmarketcap-exchangelistings.csv", header=TRUE)

# Review the data and print a brief statistical summary of the data
str(exchangelistings)
View(exchangelistings)
summary(exchangelistings)

# Determine if there is a correlation between Market Capitalization and Exchange Data
# EXPECTED RESULT: 50%
cor(exchangelistings$market.capitalization,exchangelistings$exchange.listings, use = "na.or.complete")
cor(exchangelistings$market.capitalization,exchangelistings$exchange.listings, use = "pairwise.complete")

# Create histograms of Market Capitalization and Exchange Listings
# Use 50 breaks
hist(exchangelistings$market.capitalization, breaks = 1000, xlab = "Market Capitalization", main = "Histogram of Market Capitalization")
hist(exchangelistings$exchange.listings, breaks = 1000, xlab = "Exchange Listings", main = "Histogram of Exchange Listings")

# Create Boxplots of Market Capitalization and Exchange Listings
exchangemax <- max(exchangelistings$exchange.listings, na.rm = TRUE)
capitalizationmax <- max(exchangelistings$market.capitalization, na.rm = TRUE)
boxplot(exchangelistings$market.capitalization, horizontal = TRUE, frame=FALSE, ylim=c(0,capitalizationmax), main="Boxplot of Market Capitalization")
boxplot(exchangelistings$exchange.listings, horizontal = TRUE, frame=FALSE, ylim=c(0,exchangemax), main="Boxplot of Exchange Listings")

# Create Q-Q Plots of Market Capitalization and Exchange Listings
# REASON: To show how obervations differ from normality
qqnorm(exchangelistings$market.capitalization, main = "Market Capitalization Quantile-Quantile Plot")
qqnorm(exchangelistings$exchange.listings, main = "Exchange Listings Quantile-Quantile Plot")

# Create a plot of Market Capitalization against Exchange Listings
# Additionally: Create a plot of the log of Market Capitalization against Exchange Listings
# Additionally: Add the regression line and show the statistical summary
y=exchangelistings$market.capitalization
x=exchangelistings$exchange.listings
plot(x,y,xlab="Exchange Listings", ylab="Market Capitalization", main="Plot of Value against Number of Listings", log = "y")
plot(x,y,xlab="Exchange Listings", ylab="Market Capitalization", main="Plot of Value against Number of Listings")
abline(lm(y~x))
summary(lm(y~x))
