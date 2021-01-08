## Simple CW-IRSL function for freshly irradiated feldspars
rm(list = ls(all=T))
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")
##set color space for color blind persons
col <- khroma::color("bright")()
## define parameters
rho <- .013                                   # dimensionless acceptor density
dr <- .05                                     # step in dimensionless distance r
rprimes <- seq(0, 2.2, dr)                    # values of r=0-2.2 in steps of dr
A <- 3                                        # A=stun*sigma*I/B
timesCW <- seq(1, 100)                        # IR excitation times

## calculate
distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)  # unfaded distribution
afterIRSL_distr <- CWfortimeT(max(timesCW), rho, rprimes, A)
IRsignal <- stimIRSL(timesCW, rho, rprimes, A, distr) # CW-IRSL signal
CWcurves <- t(CWsignal(timesCW, rho, rprimes, A, distr))

## plotting
par(mfrow = c(1,3))
plot(
  rprimes,
  distr,
  type = "o",
  pch = 1,
  col = "black",
  ylab = "Distribution of r'",
  xlab = "Dimensionless distance r'",
  main = "(A) Distribution of r'"
)
lines(
  rprimes,
  afterIRSL_distr,
  type = "o",
  pch = 2,
  col = col[1],
  ylab = "Distribution of r'",
  xlab = "Dimensionless distance r'"
)
legend(
  "topright",
  bty = "n",
  legend = c("before IR", "after IR"),
  col = c("black", col), 
  pch = c(1,2),
  lty = 1
)
matplot(
  timesCW,
  CWcurves,
  type = "l",
  lty = "solid",
  lwd = 1,
  xlab = expression("Time [s]"),
  ylab = "CW-IRSL [a.u.]",
  col = rgb(0,0,0,0.2),
  main = "(B) CW-IRSL curves"
)
matplot(
  timesCW,
  CWcurves[,seq(2,ncol(CWcurves),length.out = 7)],
  type = "l",
  lty = "solid",
  lwd = 1,
  col = col,
  add = TRUE 
)
legend(
  "topright",
  bty = "n",
  legend = c("0 <= r' <= 2.2", colnames(CWcurves[,seq(2,ncol(CWcurves),length.out = 7)])),
  lwd = 1,
  col = c("black", col)
)
plot(
  timesCW,
  IRsignal,
  type = "p",
  lwd = 1,
  pch = 1,
  col = col[2],
  xlab = expression("Time [s]"),
  ylab = "CW-IRSL [a.u.]", 
  main = "(C) Sum CW-IRSL signal"
)
legend(
  "topright",
  bty = "n",
  legend = c("Numerical solution", "Analytical solution"),
  col = c("red", "blue"), 
  pch = c(1, NA), 
  lty = c(NA, 1)
)
lines(
  timesCW,
  3 * rho * A * 1.8 * exp(-rho * (log(1 + 1.8 * A * timesCW)) ** 3.0) *
    (log(1 + 1.8 * A * timesCW) ** 2.0) / (1 + 1.8 * A * timesCW),
  lwd = 2,
  col = col
)
