#Fit CW-IRSL data with KP-CW equation
rm(list = ls(all=T))
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
## load data
mydata <- read.table("ph300s0IR.asc", sep = ",")[,c(1,3)]
colnames(mydata) <- c("t", "y")

## fitting
fit_data <- mydata
fit <-
  suppressWarnings(minpack.lm::nlsLM(
    formula = y ~ imax * exp (-rho * (log(1 + A * t)) ^ 3) *
      (log(1 + A * t) ^ 2) / (1 +  t * A) + bgd,
    data = fit_data,
    start = list(
      imax = 3,
      A = 1.1,
      rho = 0.03,
      bgd = min(mydata$y)
    )
  ))

imax_fit <- coef(fit)[1]
A_fit <- coef(fit)[2]
rho_fit <- coef(fit)[3]
bgd_fit <- coef(fit)[4]

## plotting
par(mfrow = c(1, 1)) 
plot(
  mydata,
  log = "xy",
  xlab = "Time [s]",
  ylab = "CW-IRSL [cts/s]",
  col = rgb(0,0,0,0.5),
  main = "CW-OSL of KST4 feldspar"
)

## plot analytical solution
lines(
  predict(fit),
  col = col[2],
  lwd = 2
)
legend(
  "topright",
  bty = "n",
  pch = c(1, NA),
  lwd = 1,
  lty = c(NA, "solid"),
  legend = c('Experiment', 'KP-CW equation'),
  col = c("black", col[2])
)
