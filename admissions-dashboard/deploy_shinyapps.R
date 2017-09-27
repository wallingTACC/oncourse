#install.packages("rsconnect", type = "source")

library(rsconnect)
rsconnect::setAccountInfo(name='username',
                          token='token',
                          secret='secret')


rsconnect::deployApp()
