rm(list=ls())
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
## set parameters
s <- 3e+15 # frequency factor
rho <- 1e-6 # rho-prime values 0.005-0.02
rc <- 0.0 # for freshly irradiated samples, rc=0
timesAF <- 3.154e7 * c(0, 1e+2, 1e+4, 1e+6)          # times in seconds
rprimes <- seq(from = rc, to = 2.2, by = 0.002)    # rprime=0-2.2
distribs <- sapply(timesAF, AFfortimeT, rprimes, rho, s)

## plotting
matplot(
  rprimes,
  distribs,
  xlab = "Dimensionless distance r'",
  ylab = "Nearest neighbor distribution g(r')",
  type = "l",
  main = "Nearest neighbor distributions",
  lwd = 2, 
  col = col
)
legend(
  "topright",
  bty = "n",
  lty = c(1, 2, 3, 4),
  lwd = 1.5,
  col = col,
  legend = c(
    "t = 0 a",
    expression("10" ^ "2" * " a"),
    expression("10" ^ "4" * " a"),
    expression("10" ^ "6" * " a")
  )
)
