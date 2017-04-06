#install.packages("rsconnect", type = "source")

library(rsconnect)
rsconnect::setAccountInfo(name='walling-tacc',
                          token='5BB39DD8ED59E2AB13133DB4FA2609D4',
                          secret='lvToUmitJnlBTAKH/WTEFYApSdO9OhNOa1ftAPBC')


rsconnect::deployApp()
