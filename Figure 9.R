## Simple TL function for freshly irradiated feldspars
rm(list = ls(all=T))
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
## set parameters
rho <- .013                     # dimensionless acceptor density
s <- 3.5e12                     # frequency factors in s^-1
E <- 1.45                       # energy in eV
tph <- 10                       # preheat time (s)
dr <- .1                        # step in dimensionless distance r'
rprimes <- seq(0.01, 2.2, dr)   # values of r'=0-2.2 in steps of dr
beta <- 1

########################## Simulations ###############
distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
temp <- 1:400                   # temperatures for TL

distr_afterTL <- heatTo(max(temp), E, s, beta, rho, rprimes, distr = NULL)
manyTL <- t(TLsignal(temp, E, s, rho, rprimes))
TL <- stimTL(temp, E, s, rho, rprimes)

## plotting
par(mfrow = c(1, 3))
plot(
  rprimes,
  distr,
  ylim = c(0, 1.5),
  typ = "o",
  pch = 1,
  col = "black",
  ylab = "Distribution of r'",
  xlab = "Dimensionless distance r'",
  main = "(A) Distribution of r'"
)
lines(
  rprimes,
  distr_afterTL,
  typ = "o",
  pch = 2,
  col = col[2],
  ylab = "Distribution of r'",
  xlab = "Dimensionless distance r'"
)
legend(
  "topleft",
  bty = "n",
  lty = 1, 
  pch = c(1,2), 
  col = c("black", col[2]),
  legend = c("before TL", "after TL")
)
matplot(
  temp,
  manyTL,
  typ = "l",
  lty = "solid",
  col = rgb(0,0,0,0.2),
  xlim = c(140, 400),
  ylim = c(0, .025),
  lwd = 1,
  main = "(B) TL curves for each r'",
  xlab = "Temperature [\u00b0C]",
  ylab = "TL [a.u.]"
)
matplot(
  temp,
  manyTL[,seq(1,ncol(manyTL), length.out = 7)],
  typ = "l",
  lty = "solid",
  col = col,
  lwd = 1,
  add = TRUE
)
legend(
  "topleft",
  bty = "n",
  col = c("black", col),
  lwd = 1,
  legend = c("0 <= r' <= 2.2", colnames(manyTL[, seq(1, ncol(manyTL), length.out = 7)]))
)
plot(
  temp,
  TL,
  typ = "l",
  lwd = 2,
  pch = 1,
  col = "black",
  xlim = c(140, 400),
  ylim = c(0, .012),
  xlab = "Temperature [\u00b0C]",
  ylab = "TL [a.u.]",
  main = "(C) Sum TL curves"
)