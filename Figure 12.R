## Multiple feldspar irradiations, various burial temperatures

rm(list = ls(all=T))
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
## set variables
rho <- 1e-2                   # dimensionless acceptor density
s <- 2e+15                    # frequency factors in s^-1
E <- 1.3                      # energy in eV
D0 <- 1600                    # D0 in Gy
yr <- 365 * 24 * 3600         # year is seconds
Ddot <- 2.85 / (1e+3 * yr)    # low natural dose rate = 1 Gy/kA
dr <- .05                     # step in dimensionless distance r'
rprimes <- seq(0.01, 2.2, dr) # values of r'=0-2.2 in steps of dr
tirr <- 1e+3 * yr             # set fixed irradiation time
Tirrs <- c(-4, 0, 4, 8)       # burial temperatures

## calculate distribution
distribs <- irradatsometemp(Tirrs, tirr, E, s, rho, rprimes, D0, Ddot)

## plotting 
par(mfrow = c(1, 1))
pchs = c(1, 2, 3, 4)
matplot(
  rprimes,
  distribs,
  typ = "o",
  pch = pchs,
  col = col,
  #ylim = c(0, .003),
  lty = "solid",
  xlab = "Dimensionless distance r'",
  ylab = "Distribution of r'",
  lwd = 1, 
  main = "Irradiation for various burial temperatures"
)
legend(
  "topright",
  bty = "n",
  lwd = 1,
  legend = paste(Tirrs, "\u00b0C"),
  pch = pchs,
  col = col
)