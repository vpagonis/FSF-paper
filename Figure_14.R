rm(list = ls(all=T))
options(warn=-1)
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
mydata <- read.table("ph300s0.asc", sep = ",")[,c(1,3)]
colnames(mydata) <- c("t", "y")

## normalise
mydata$y <- mydata$y / max(mydata$y)

## fitting
kb <- 8.617e-5
z <- 1.8
kB <- 8.617E-5
En <- 1.45
T <- mydata$t + 273.15

fit <- minpack.lm::nlsLM(
  formula = y ~ imax * 
    exp(-rho * ((
      log(1 + z * s * kB * ((T ^ 2) / abs(En)) * exp(-En / (kB * T)) * (1 - 2 * kB * T / En))) ^ 3)) *
    (En ^ 2 - 6 * (kB ^ 2) * (T ^ 2)) * 
    ((log(1 + z * s * kB * ((T ^ 2) / abs(En)) * exp(-En / (kB * T)) * (1 - 2 * kB * T / En))) ^ 2) /
    (En * kB * s * (T ^ 2) * z - 2 * (kB ^ 2.0) * s * z * (T ^ 3) + exp(En / (kB * T)) * En),
  data = mydata,
  start = list(imax = 1e+12, s = 1e+11, rho = .009),
  upper = c(1e+20, 1e+13, .02),
  lower = c(1e+11, 1e+11, .008)
)

# obtain parameters from best fit
imax_fit <- coef(fit)[1]
s_fit <- coef(fit)[2]
rho_fit <- coef(fit)[3]
En_fit <- En

## plotting
par(mfrow = c(1, 1))
plot(
  mydata,
  xlab = "Temperature [\u00B0C]",
  ylab = "Normalized TL",
  col = rgb(0,0,0,0.8),
  pch = 1,
  xlim = c(200, 450),
  main = "TL of KST4 feldspar"
)
lines(predict((fit)), col = col[2], lwd = 2)

legend(
  "topleft",
  bty = "n",
  pch = c(1, NA),
  lwd = 1,
  lty = c(NA, "solid"),
  legend = c('Experiment', 'KP-CW equation'),
  col = c("black", col[2])
)
