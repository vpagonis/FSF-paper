rm(list = ls(all=T))
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")
##set color space for color blind persons
col <- khroma::color("bright")()
##set parameters
rho <- 1e-6 # dimensionless acceptor density
dr <- .01   # Step in dimensionless distance r'
rprimes <- seq(0, 2.2, dr) # values of r'=0-2.2 in steps of dr
s <- 3e+15

## fading times in years but recalculated to seconds
timesAF <- c(10, 3.154e+7 * 
               c(.1, .2, .5, 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 1e4))

## calculate values
n <- dr * colSums(AFfortimeT(timesAF, rprimes, rho, s))

## plotting left plot . long term fading over 10,000 years
par(mfrow = c(1, 2))
plot(
  timesAF / (3.154e7),
  100 * n,
  typ = "p",
  lwd = 2,
  pch = 1,
  main = "(A) AF in nature",
  col = col[2],
  ylim = c(70, 110),
  xlab = expression("Time [a]"),
  ylab = "Remaining charge [%]"
)

##add starting point
lines(x = c(10/3.154e7, .22e+11/3.154e7), y = c(95,96.2))
text(1e+10/3.154e7, 96, "10 s", pos = 4)

##add analytical solution
lines(
  timesAF / 3.154e7,
  y = 100 * exp(-rho * (log(1.8 * s * timesAF)^3.0)),
  lwd = 2,
  col = col[1]
)
legend(
  "topleft",
  bty = "n",
  legend = c("FSF", "Analyt. solution"),
  lwd = 2,
  lty = c(NA, 1),
  pch = c(1, NA),
  col = col
)

### Repeat for short term fading 0-10 days in lab
timesAF <- c(10, 86400 * c(1e-4, 1e-3, 1e-2, .1, .2, .5, seq(1, 10, .5)))
n <- dr * colSums(AFfortimeT(timesAF, rprimes, rho, s))

##plot right plot (short term fading over 10 days)
plot(
  timesAF / 86400,
  100 * n,
  typ = "p",
  lwd = 2,
  pch = 1,
  main = "(B) AF in lab",
  col = col[2],
  ylim = c(70, 110),
  xlab = "Time [d]",
  ylab = "Remaining charge [%]"
)

##add starting point
lines(x = c(10/86400, .4e+5/86400), y = c(95,96.2))
text(10/86400, 96, "10 s", pos = 4)

##add analytical solution
lines(
  timesAF / 86400,
  y = 100 * exp(-rho * (log(1.8 * s * timesAF)^3.0)),
  lwd = 2,
  col = col[1]
)
