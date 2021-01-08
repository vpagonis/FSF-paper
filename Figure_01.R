rm(list = ls(all = TRUE)) # empties the environment
##load packages and FSF 
library("plot3D")
library("FNN")
library("khroma")
library("minpack.lm")
source("Functions_FSFpaper.R")

##set color space for color blind persons
col <- khroma::color("bright")()
# Fig 1 in Pagonis and Kulp paper
# Original Mathematica Program written by V Pagonis
# R version written by Johannes Friedrich

## Define parameters
set.seed(27182821) #set set for random number generator (for reproducibility)
sideX <- 100e-9 # length of cuboid in m
sideX_nm <- sideX * 1e+9 # length of cuboid in nm
N_pts <- 50
alpha <- 9e+9
N_centers <- 300
rho <- N_centers / sideX ^ 3

r_prime <- function(r)
  (4 * pi * rho / 3) ^ (1 / 3) * r * 1e-9

xyz_traps <- data.frame(
  x = sample(1:sideX_nm, N_pts, replace = TRUE),
  y = sample(1:sideX_nm, N_pts, replace = TRUE),
  z = sample(1:sideX_nm, N_pts, replace = TRUE)
)
xyz_centers <- data.frame(
  x = sample(1:sideX_nm, N_centers, replace = TRUE),
  y = sample(1:sideX_nm, N_centers, replace = TRUE),
  z = sample(1:sideX_nm, N_centers, replace = TRUE)
)

##plot
par(mfrow = c(1, 2))
plot3D::scatter3D(
  xyz_centers$x,
  xyz_centers$y,
  cex = .3,
  xyz_centers$z,
  bty = "g",
  pch = 1,
  theta = 30,
  phi = 30,
  col = col[1], 
  main = "(A) Dosimetric system"
)
plot3D::scatter3D(
  xyz_traps$x,
  xyz_traps$y,
  cex = .5,
  xyz_traps$z,
  bty = "g",
  pch = 17,
  theta = 30,
  phi = 30,
  col = col[2],
  add = TRUE
)

## find nearest neighbour
dist <- FNN::get.knnx(
  data = as.matrix(xyz_centers),
  query = as.matrix(xyz_traps),
  k = 1
)

## plot histogram
distance_nm <- as.vector(dist$nn.dist)

h <- hist(
  distance_nm,
  xlim = c(0, 22),
  main = "(B) Nearest neighbors",
  breaks = "FD",
  xlab = "Distance [nm]"
)

## provide analytical solution
r <- seq(0, 22, 0.1)
distr_ana <- 3 * 8 * r_prime(r)^2 * exp(-(r_prime(r)^3))

## plot analytical solution
lines(x = r,  y = distr_ana)
