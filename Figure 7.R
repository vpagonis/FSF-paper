## Feldspar irradiation in laboratory
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
rho <- 2e-6                               # dimensionless acceptor density
s <- 3e15               	                # frequency factors in s^-1
D0 <- 538                                 # D0 in Gy
Ddot <- 0.1 * 3.15576e+10                 # high laboratory dose rate = 0.1 Gy/s
dr <- .05                                 # step in dimensionless distance r'
rprimes <- seq(0.01, 2.2, dr)             # values of r'=0-2.2 in steps of dr
irrTimes <- 10 ^ seq(1, 5, by = .2)

##run calculation
distribs <- irradfortimeT(irrTimes, rprimes, rho, s, Ddot, D0)

##plotting
par(mfrow=c(1,2))
matplot(
  rprimes,
  distribs,
  typ = "l",
  ylim = c(0, 1.5),
  lty = "solid",
  col = col,
  xlab = "Dimensionless distance r'",
  ylab = "Distribution of r'",
  main = "(A) Irradiation in lab",
  lwd = 1
)
legend("topleft", bty = "n", legend =
         expression(paste(t[irr], " =1-10" ^ "6" * " s")))
plot(
  irrTimes,
  colSums(distribs) * dr,
  typ = "p",
  lwd = 1,
  xlab = "Time [s]",
  ylab = "Trap filling ratio n(t)/N",
  ylim = c(0, 1),
  main = "(B) Trap filling n(t)/N"
)
legend(
  "topleft",
  bty = "n",
  legend = "Analytical Eq.",
  lwd = 1,
  lty = c(1),
  col = col[2]
)
Ddot <- Ddot/3.15576e+10
lines(
  x = irrTimes,
  y = (1 - exp(-(Ddot * irrTimes) / D0)) * exp(-rho * (log(D0 * s / Ddot) ^ 3.0)),
  lwd = 1,
  col = col[2]
)