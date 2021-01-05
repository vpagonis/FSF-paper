##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
##set parameters
rho <- 2e-6                                     # dimensionless acceptor density
D0 <- 538                                       # D0 in Gy
Ddot <- 3                                       # low natural dose rate in Gy/ka
rprimes <- seq(0.01, 2.2, .04)                  # values of r 0-2.2 in steps of .01
s <- 2e+15                                      # frequency factors in s^-1
irrTimes <- c(6.67e4, 1.67e5, 1e6) * 3.15576e+7   
unfaded <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)  # unfaded sample
distribs <- irradfortimeT(irrTimes, rprimes, rho, s, Ddot, D0)

########## plot distributions
matplot(
  rprimes,
  distribs,
  ylab = "Nearest neighbor distribution g(r')",
  typ = "o",
  lty = "solid",
  xlab = "Dimensionless distance r'",
  pch = c(2, 3, 4),
  main = "Natural irradiation",
  lwd = 1,
  col = col
)
lines(
  rprimes,
  unfaded,
  col = "black",
  pch = 1,
  typ = "p",
  lwd = 1
)
legend(
  "topright",
  bty = "n",
  legend = c(
    expression(
      "unfaded",
      "t_irr = 6.7x10" ^ 4 * " a",
      "t_irr = 1.7x10" ^ 5 * " a",
      "field saturation"
    )
  ),
  col = c("black", col),
  pch = c(1, 2, 3, 4)
)