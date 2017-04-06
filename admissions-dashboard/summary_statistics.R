source('./simulated_data.R')

# Example Shool Admissions summary plots

# Exploration
aggies <- reg_data[reg_data$school=='Texas A&M',]
longhorns <- reg_data[reg_data$school=='UT',]
# Admissions by Grad Type
counts <- table(reg_data$hs_grad_type)

barplot(counts/sum(counts), main="Admissions by Grad Type",
        xlab="Grad Type", ylab='Percentage of Accepted') 

# More advanced bar plots for grad type
library(ggplot2)
plot_data <- reg_data[reg_data$accepted==1 & reg_data$school==c('Texas A&M', 'Texas Tech'),]

qplot(hs_grad_type, data=plot_data, geom="bar", fill=plot_data$school)

# Example cohort year by year plot

library(reshape2)
plot_data <- melt(cohort_data, measure.vars = c('year1', 'year2', 'year3'), variable.name='year')
plot_data$status <- ordered(plot_data$value, levels=c('un-enrolled', 'dropout', 'enrolled', 'graduated'))
qplot(year, data=plot_data, geom="bar", fill=status)

# Example cohort year by year plot

library(sqldf)
melted <- melt(cohort_data, measure.vars = c('year1', 'year2', 'year3'), variable.name='year')
totals <- sqldf('select hs_grad_type, race, count(*) as num from melted group by 1, 2')
years <- sqldf('select year, hs_grad_type, race, count(*) * 1.0 as num from melted group by 1, 2, 3')
plot_data <- sqldf('select a.year, a.hs_grad_type, a.race, a.num/b.num from years a join totals b
                   on a.hs_grad_type=b.hs_grad_type and a.race=b.race')



plot_data$status <- ordered(plot_data$value, levels=c('un-enrolled', 'dropout', 'enrolled', 'graduated'))
qplot(year, data=plot_data, geom="bar", fill=status)