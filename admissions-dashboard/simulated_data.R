set.seed(1)

# Common Factors
race_fct <- as.factor(c('White', 'Black', 'Hispanic', 'Asian', 'Other'))
hs_fact <- as.factor(c('Austin High', 'Westlake', 'Bowie'))
college_fct <- as.factor(c('UT Austin', 'Texas A&M', 'Texas Tech', 'Texas State', 'UT Brownsville', 'UT Tyler', 'Houston', 'Rice', 'UT Elpaso'))
hs_grad_type_fct <- as.ordered(c('low', 'mid', 'high'))
levels(hs_grad_type_fct) <- c('low', 'mid', 'high')
college_grad_status_fct <- as.ordered(c('un-enrolled', 'dropout', 'enrolled', 'graduated'))
levels(college_grad_status_fct) <- c('un-enrolled', 'dropout', 'enrolled', 'graduated')

next_grad_status <- function(grad_status) {
  # Return random next status with simple heuristics
  if(grad_status=='un-enrolled') {
    # un-enrolled or enrolled
    return(sample(college_grad_status_fct[college_grad_status_fct %in% c('un-enrolled', 'enrolled')], size=1))
  }
  else if(grad_status=='dropout') {
    return(sample(college_grad_status_fct[college_grad_status_fct %in% c('un-enrolled', 'enrolled', 'dropout')], size=1))
  }
  else if(grad_status=='enrolled') {
    return(sample(college_grad_status_fct[college_grad_status_fct %in% c('enrolled', 'dropout', 'graduated')], size=1))
  }
  else if(grad_status=='graduated') {
    return(college_grad_status_fct[1]) # TODO: Why not index 4.  F this factor ordering crap
  }
}

is_accepted <- function(hs_grad_type, gpa, sat, num_adv) {
  # Function allows us to simulate data with basic heuristics
  # I.e. higher gpa gives higher chance of accepted
  prob <- (0.25 * (as.numeric(hs_grad_type)/3.0)) + 
          (0.25 * (gpa / 4.0)) + 
          (0.25 * (sat / 1600.0)) +
          (0.25 * (num_adv / 10.0))
  return(sample(0:1, prob=c(1-prob,prob), size=1))
}

size = 2000


# Data for regression modesl
# We base some values on others, namely 'accepted' so we need to create those first
hs_grad_type <- sample(hs_grad_type_fct, size=size, replace=T)
gpa <- runif(n=size, min=2.0, max=4.0)
sat <- sample(800:1600, size=size, replace=T)
num_adv <- sample(0:10, size=size, replace=T)
num_dual_credit <- sample(0:10, size=size, replace=T)
accepted <- sapply(1:size, function(i){
  is_accepted(hs_grad_type[i], gpa[i], sat[i], num_adv[i])
})
reg_data <- data.frame(id=1:size, 
                      accepted=accepted, 
                      school=sample(college_fct, size=size, replace=T),
                      hs_grad_type=hs_grad_type,
                      num_adv=num_adv,
                      num_dual_credit=num_dual_credit,
                      gpa=gpa,
                      sat=sat
                      )

# Data for cohort visualizations
year1 <- sample(college_grad_status_fct[college_grad_status_fct %in% c('un-enrolled', 'enrolled')], size=size, replace=T)
year2 <- as.ordered(sapply(year1, next_grad_status))
year3 <- as.ordered(sapply(year2, next_grad_status))
year4 <- as.ordered(sapply(year3, next_grad_status))
year5 <- as.ordered(sapply(year4, next_grad_status))
year6 <- as.ordered(sapply(year5, next_grad_status))
cohort_data <- data.frame(id=1:size,
                      race=sample(race_fct, size=size, replace=T),
                      hs_grad_type=sample(hs_grad_type_fct, size=size, replace=T),
                      year1=year1,
                      year2=year2,
                      year3=year3,
                      year4=year4,
                      year5=year5,
                      year6=year6
                      )