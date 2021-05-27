#################################################Shortest path problem 1 ############################################
##State variables
#Distance of each path/pair

##Choice/Decision Variables
#Choose shorter path

##Dynamics
#How do state variables today and decision today combine the change into getting new state variables?

##
#Uh huh... well I did it manually sorta.
#I wonder if there is a way to loop this.

V10 = 0

V6 = 3+V10 #= 0

V7 = 4+V10 #= 4

V8 = 2+V10 #= 2

V9 = 3+V10 #= 3

V5 = min(2+V8,2+V7)

V4 = min(4+V6,2+V8)

V3 = min(2+V7,3+V6)

V2 = min(4+V3,2+V4,4+V5)

V1 = min(2+V4,3+V3)


##########################################Cake W######################################################################
#State variables
#How many cakes does he eat each day

#Decision
#Maximize happiness

#Dynamics
#The utility changes according to the function 0.7^{t-1}\sqrt{i} where i is the number of cakes eaten

#Value equation:
#Sum up all the utilities across the different time periods

#Bellman equation:
#Defined as V()

#Terminal Equation
#V(0) = 0

#Up to 5 cakes
C = 5

#Time limit is 3
T = 3

sValues = seq(0,C) #all possible cakes
tValues = seq(0,T) #all possible times

#for iteration
sN = length(sValues) 
tN = length(tValues)

#Define value function and optimal decision
V = matrix(0,sN,tN)
U = matrix(0,sN,tN)

#Define terminal condition. Day 4 is 0.
V[,tN] = 0
U[,tN] = 0

for (ti in (tN-1):1){ # loop backwards in time
  for (si in 1:(sN)){ # loop over all possible tons of ore in mine
    
    t=tValues[ti] # what is the actual time and tons in the mine
    s=sValues[si] 
    
    X = seq(0,s) # all possible sequences of cakes
    valueChoices= sqrt(X)*0.7^(t-1)+V[si-X,ti+1] # for each possible decision, what would the value function be?
    
    V[si,ti]=max(valueChoices) # pick the one that maximizes that value
    U[si,ti]=which.max(valueChoices)-1 # minus 1 because X starts at 0...
    
    
  }
}

# now that we have solved it backwards, let's implement the solution going forwards
s=C # at the initial time there are 5 cakes
for (t in 1:T){
  si=s+1 # recall starting at zero vs 1 means you need to add 1 to the index
  print(paste("Day:", t , " Initial cakes:",s, "Ate:", U[si,t]))
  s=s-U[si,t] # remove this amount from the mine
}



