#Dose response of feldspars, irradiation in nature
rm(list = ls(all=T))
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
rho <- 1e-3                             # dimensionless acceptor density
Po <- s <- 2e+15                        # frequency factors in s^-1
E <- 1.3                                # energy in eV
D0 <- 1600                              # D0 in Gy
yr <- 365 * 24 * 3600                   # year in seconds
Ddot <- 2.85 / (1e+3 * yr)              # low natural dose rate = 1 Gy/ka
dr <- .05                               # step in dimensionless distance r'
rprimes <- seq(0.01, 2.2, dr)           # values of r'=0-2.2 in steps of dr
Tirr <- -4
irrTimes <-
  c(1e+2,
    1e+3,
    5e+3,
    1e+4,
    3e+4,
    6e+4,
    1e+5,
    1.5e+5,
    2e+5,
    4e+5,
    6e+5,
    8e+5,
    1e+6) *
  yr

## calculate distributions
distribs <- irradandThermalfortimeT(Tirr = -4, irrTimes, E, s, rho, rprimes, D0, Ddot)

## plotting
par(mfrow = c(1, 2))
matplot(
  rprimes,
  distribs,
  type = "l",
  lty = "solid",
  col = rgb(0,0,0,.5),
  xlab = "Dimensionless distance r'",
  ylab = "Distribution of r'",
  lwd = 1, 
  main = "(A) Irradiation in nature"
)
matplot(
  rprimes,
  distribs[,seq(1,ncol(distribs),length.out = length(col))],
  type = "l",ylim=c(0,1),
  lty = "solid",
  col = col,
  lwd = 1, 
  add = TRUE
)
legend(
  "topleft",
  bty = "n",
  lwd = 1,
  col = c("black", col),
  legend = c(expression(paste(
    t[irr], "=10" ^ 3 * "-10" ^ 6 * "a"
  )),
  paste(format(
    as.numeric(colnames(distribs[, seq(1, ncol(distribs), length.out = length(col))])), digits = 1
  ), "a")), 
  cex = 0.7
)
plot(
  irrTimes / yr,
  colSums(distribs) * dr,
  type = "o",
  lwd = 1,
  xlab = "Time [a]",
  ylab = "Trap filling ratio n(t)/N",
  main = "(B) Trap filling n(t)/N"
)
