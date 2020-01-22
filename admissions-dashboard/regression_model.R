# Script to create the regression model for the app
# End result should be a .Rdata file containing the model, which can be loaded into the app

#setwd('/home/walling/dev/TERC-Crews/CollAppProto/')
source('./simulated_data.R')

model <- glm(accepted~school_fct+hs_grad_type_fct+num_adv+num_dual_credit+gpa+act+school_fct:gpa+school_fct:act, data=reg_data)

summary(model)

# Test
library(dplyr)
test_data <- sample_n(reg_data, size=5)

predictions <- predict(model, newdata=test_data, type='response')

# Plot predictions
library(ggplot2)
ggplot(test_data, aes(x=school_fct, y=predictions)) +
  geom_bar(stat="identity") +
  ylim(0,1)


# Save results

save(list=c('model'), file="./model.Rdata")