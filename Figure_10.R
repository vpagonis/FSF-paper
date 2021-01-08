## Examples of TL for thermally and optically treated samples
##load packages and FSF 
rm(list = ls(all=T))
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")
##set color space for color blind persons
col <- khroma::color("bright")()
rho <- .013                       # dimensionless acceptor density
Po <- s <- 3.5e12                 # frequency factors in s^-1
E <- 1.45                         # energy in eV
Tph <- 320                        # preheat temperature (deg C)
tph <- 30                         # preheat time (s)
dr <- .05                         # step in dimensionless distance r'
rprimes <- seq(0.01, 2.2, dr)     # values of r'=0-2.2 in steps of dr
beta <- 1
A <- 5
distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)  # unfaded distribution
temps <- 1:500                    # temperatures for TL

par(mfrow = c(1, 2))
## calculate unfaded signal
TL1 <- stimTL(temps, E, s, rho, rprimes)             
distr_afterTL1 <- heatTo(Tph, E, s, beta, rho, rprimes)

## calculate TL after TL1 (taking this distribution)
TL2 <- stimTL(temps, E, s, rho, rprimes, distr_afterTL1)     

## calculate new TL with new distribution
distr_afterTstop<-heatTo(Tph, E, s, beta, rho, rprimes)
#plot(rprimes,distr1)
distr_afterTLPH30 <- heatAt(Tph, tph, E, s, rprimes,distr=distr_afterTstop)
#lines(rprimes,distr_afterTLPH30)
TL3 <- stimTL(temps, E, s, rho, rprimes, distr_afterTLPH30)  

## Example #4: CW-IRSL excitation for 50 s, then measure TL
timesCW <- 1:50
distr_afterCW10 <- CWfortimeT(max(timesCW), rho, rprimes, A)
TL4 <- stimTL(temps, E, s, rho, rprimes, distr_afterCW10) 

## plotting
plot(
  rprimes,
  distr,
  ylim = c(0, 1.5),
  typ = "l",
  pch = 1,
  col = "black",
  lwd = 1,
  ylab = "Distribution of r'",
  xlab = "Dimensionless distance r'",
  main = "(A) Distributions of r'"
)
lines(rprimes,
      distr_afterTL1,
      typ = "l",
      col = col[1],
      lwd = 1)
lines(
  rprimes,
  distr_afterTLPH30,
  typ = "l",
  col = col[2],
  lwd = 1
)
lines(
  rprimes,
  distr_afterCW10,
  typ = "l",
  col = col[3],
  lwd = 1
)
text(
  x = c(rprimes[which.max(distr)],
        rprimes[which.max(distr_afterTL1)],
        rprimes[which.max(distr_afterTLPH30)],
        rprimes[which.max(distr_afterCW10)]),
  y = c(
    max(distr),
    max(distr_afterTL1),
    max(distr_afterTLPH30),
    max(distr_afterCW10)
  ),
  pos = 2,
  labels = c("1", "2", "3", "4")
)
plot(
  temps,
  TL1,
  xlim = c(200, 450),
  ylim = c(0, .015),
  typ = "l",
  col = "black",
  lwd = 1,
  xlab = "Temperature [\u00b0C]",
  ylab = "TL [a.u.]",
  main = "(B) Corresponding TL"
)
lines(temps,
      TL2,
      typ = "l",
      col = col[1],
      lwd = 1)
lines(temps,
      TL3,
      typ = "l",
      col = col[2],
      lwd = 1)
lines(temps,
      TL4,
      typ = "l",
      col = col[3],
      lwd = 1)
text(
  x = c(temps[which.max(TL1)],
        temps[which.max(TL2)],
        temps[which.max(TL3)],
        temps[which.max(TL4)]),
  y = c(
    max(TL1),
    max(TL2),
    max(TL3),
    max(TL4)
  ),
  pos = 2,
  labels = c("1", "2", "3", "4")
)
