# Dynamic Programming various problems
  
This details the various problems that I've done that relate to dynamic programming. 
  
## Problem 1: Shortest Path Problem
In the network pictured below, find the shortest path from node 1 to node 10 and the shortest path from node 2 to node 10.  
![Dynamic Problem 1](dyn_pro_1.jpg)  

For this problem, the solution is to simply do backwards induction. As detailed in the following:
\begin{center}
\begin{verbatim}
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
\end{verbatim}
\end{center}