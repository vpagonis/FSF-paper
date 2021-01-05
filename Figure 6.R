## Feldspar irradiation in nature
rm(list = ls(all=T))

##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
#set parameters
rho <- 2e-6                   # dimensionless acceptor density
s <- 3e+15               	    # frequency factors in s^-1
D0 <- 538                     # D0 in Gy
yr <- 3.15576e+7              # year is seconds
Ddot <- 3                     # low natural dose rate = 2.85 Gy/Ka
dr <- .05                     # step in dimensionless distance r'
rprimes <- seq(0.01, 2.2, dr) # values of r'=0-2.2 in steps of dr
irrTimes <- 10 ^ seq(2, 6, by = .2) * yr # set irradiation times

##calculate parameters
distribs <- irradfortimeT(irrTimes, rprimes, rho, s, Ddot, D0)

########## plot distributions
par(mfrow=c(1,2))
matplot(
  rprimes,
  distribs,
  typ = "l",
  ylim = c(0, 1.4),
  lty = "solid",
  xlab = "Dimensionless distance r'",
  ylab = "Distribution of r'",
  main = "(A) Irradiation in nature",
  lwd = 1, 
  col = col
)

legend("topleft", bty = "n", legend = c(expression(paste(
  t[irr], " = 10" ^ "2" * "-10" ^ "6" * "a"
))))

plot(
  irrTimes / yr,
  colSums(distribs) * dr,
  typ = "p",
  lwd = 1,
  xlab = "Time [a]",
  ylab = "Trap filling ratio n(t)/N",
  ylim = c(0, .8), 
  main = "(B) Trap filling n(t)/N"
)

Ddot <- Ddot/3.15576e+10
lines(
  x = irrTimes / yr,
  y = (1 - exp(-Ddot * irrTimes / D0)) * exp(-rho * (log(D0 * s / Ddot) ^ 3.0)),
  lwd = 1,
  col = col[2]
)

legend(
  "topleft",
  bty = "n",
  legend = "Analytical solution",
  lwd = 2,
  lty = c(1),
  col = col[2]
)