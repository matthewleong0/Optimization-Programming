####################################### Triangle Area Optimization #############################################
library(Rsolnp)

area <- function(x){ # function for area of a triangle given its sides, x is a vector containing a,b,c
  s = (x[1]+x[2]+x[3])/2
  area = sqrt(s*(s-x[1])*(s-x[2])*(s-x[3]))
  return(-area)
}

equal <- function(x){#takes in the a,b,c values and adds them together
  total = x[1]+x[2]+x[3]
  return(total)
}

S = solnp(c(15,25,20), #starting values (random - obviously need to be positive and sum to 60)
          area, #function to optimise
          eqfun=equal, #equality function 
          eqB=60,   #the equality constraint
          LB=c(0,0,0), #lower bound for parameters i.e. greater than zero
          UB=c(60,60,60)) #upper bound for parameters

S$values

#I guessed the optimal fencing at first glance. Guess that's a math major intuition. 
#Makes sense equilateral triangles are optimal for area.
S$pars




###################################### Resource Allocation #########################################################
#$12 per hour of labor
#$15 per hour of capital
#objective is 0.05L^{2/3}K^{1/3}
#100,000 available cash
#In theory then 12L+15K = 100,000
#So K = (100000-12L)/15

library(Rsolnp)

test <- function(L){ # function for num of machines produced given a level of L
  K = (100000 - 12*L)/15
  num_machines = 0.05*L^(2/3)*K^(1/3)
  return(-num_machines)
}
S = solnp(100, test,LB = 0)
S$pars
#Look atS4values and the last value which is the answer.
S$values

###################################### NFL ##########################################################################
library(tidyverse)
nfl <- read.csv('nflratings.csv',header = FALSE)
nfl <- nfl %>% rename(
  Week = V1,
  Home_Index = V2,
  Visit_Index = V3,
  Home_Score = V4,
  Visit_Score = V5
)
head(nfl)

nfl$Actual_Spread = nfl$Home_Score-nfl$Visit_Score

#Function for predicted spread. Find minimum prediction error.
#Let Adv stand for the advantage constant
get_pred_error <- function(Adv){
  pred_error = 0
  for (i in 1:nrow(nfl)) {
    #chose adv[33] because it's out of the team's index. So for now, it'll hold the count.
    pred_error = pred_error + (nfl$Actual_Spread[i]- (Adv[nfl[i,2]] - Adv[nfl[i,3]] + Adv[33]))^2
  }
  return(pred_error)
}
S = solnp(rep(1, 33), get_pred_error)
#Need to normalize ratings and set the mean to 85.
Sol = S$pars[1:32] + (85 - mean(S$pars[1:32]))
#Add in the parameter for the constant
Sol = c(Sol, S$pars[33])
#Double check and see if the mean is 85.
mean(Sol[1:32])
Sol

#Now translate those ratings into a dataframe
team_numbers = list(seq(1,32))
rating = Sol[1:32]
df = data.frame(team_numbers, rating)


#Now to compare prediction vs reality
win_or_lose = c()
for (i in nfl$Home_Score-nfl$Visit_Score){
  if (i > 0){
    win_or_lose = append(win_or_lose,"win")
  }
  else {
    win_or_lose = append(win_or_lose,"lose")
  }
}

pred_win_or_lose = c()
for (i in df$rating[nfl$Home_Index] - df$rating[nfl$Visit_Index] + Sol[33]) {
  if (i > 0){
    pred_win_or_lose = append(pred_win_or_lose,"win")
  }
  else {
    pred_win_or_lose = append(pred_win_or_lose,"lose")
  }
}

comparison = c()
for (i in 1:length(win_or_lose)) {
  if (win_or_lose[i] == pred_win_or_lose[i]){
    comparison = append(comparison,"same")
  }
  else{
    comparison = append(comparison,"different")
  }
}
length(which(comparison == 'same'))
