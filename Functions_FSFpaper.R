#'@title Anomalous fading Function (model GST)
#'
#'@description Sets parameter distribution at the end of the anomalous fading period time (in s)
#'
#'@param time [numeric] (**required**): fading times in seconds
#'
#'@param rprimes [numeric] (**required**): vector of r' values
#'
#'@param rho [numeric] (**required**): rho-prime values in seconds
#'
#'@param s [numeric] (**required**): frequency factor 
#'
#'@md
#'@export
AFfortimeT <- function(time, rprimes, rho, s) {
  ## set matrix to be filled
  m <- matrix(ncol = length(time), nrow = length(rprimes))
  
  ## run calculation
  seff <- -exp(-(rho[1] ^ (-1 / 3)) * rprimes) * s[1]
  distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
  
  for (i in 1:length(time)) {
    m[,i] <- distr * exp(seff * time[i])      
  }
  
  ## return matrix with meaningful row and column names
  rownames(m) <- rprimes
  colnames(m) <- time
  m
}
#'@title Simulate irradiation for a given time (model IGST)
#'
#'@param tirr [numeric] (**required**): irradiations times 
#'
#'@param rprimes [numeric] (**required**): vector of r' values
#'
#'@param rho [numeric] (**required**): rho-prime values in seconds
#'
#'@param s [numeric] (**required**): frequency factor 
#'
#'@param Ddot [numeric] (**required**): low natural dose rate in Gy/ka
#'
#'@param D0 [numeric] (**required**): D0 in Gy
#'
#'@md
#'@export
irradfortimeT <- function(tirr, rprimes, rho, s, Ddot, D0) {
  ## set matrix to be filled
  m <- matrix(ncol = length(tirr), nrow = length(rprimes))
  
  ## run calculation
  unfaded <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
  seff <- s * exp(-rprimes * (rho ^ (-1 / 3.0)))
  tau <- 1 / seff
  Ddot <- Ddot[1] / 3.15576e+10 
  
  for (i in 1:length(tirr)) {
    m[,i] <- unfaded * (Ddot[1] * tau / (D0[1] + Ddot[1] * tau)) *
      (1 - exp(-(D0[1] + Ddot[1] * tau) / (D0[1] * tau) * tirr[i]))
    
  }
  
  ## return matrix with meaningful row and column names
  rownames(m) <- rprimes
  colnames(m) <- tirr
  m
}
#'@title Charge distribution at the end of the IR stimulation (model EST)
#'
#'@param timCW [numeric] (**required**): times vector for the simulation
#'
#'@param rprimes [numeric] (**required**): vector of r' values
#'
#'@param rho [numeric] (**required**): rho-prime values in seconds
#'
#'@param A [numeric] (**required**): effective A
#'
#'@md
#'@export
CWfortimeT <- function(timCW, rho, rprimes, A) {
  ## set matrix to be filled
  m <- matrix(nrow = length(rprimes), ncol = length(timCW))
  
  ## run calculation
  Aeff <- A[1] * exp(-rprimes * (rho[1] ^ (-1 / 3.0)))
  distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
  
  for (i in 1:length(timCW)) {
   m[,i] <- distr * exp(-(Aeff * timCW[i]))      
  }
  
  ## return matrix with meaningful row and column names
  rownames(m) <- rprimes
  colnames(m) <- timCW
  m
}
#'@title Evaluates and returns the CW-IRSL signal (model EST)
#'
#'@param timCW [numeric] (**required**): times vector for the simulation
#'
#'@param rprimes [numeric] (**required**): vector of r' values
#'
#'@param rho [numeric] (**required**): rho-prime values in seconds
#'
#'@param A [numeric] (**required**): effective A
#'
#'@param distr [numeric] (**optional**): charge distribution at the beginning
#'of the experiment, if nothing was set, this values is calculated 
#'
#'@return [matrix] with `rprimes` (rows) and time steps (columns)
#'
#'@md
#'@export
CWsignal <- function(timCW, rho, rprimes, A, distr = NULL) {
  ## define matrix to be filled
  m <- matrix(nrow = length(rprimes), ncol = length(timCW))
  
  ## calculate distr if needed
  if (is.null(distr)) distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)

  ## run calculation
  Aeff <- A[1] * exp(-rprimes * (rho[1] ^ (-1 / 3.0)))
  
  for (i in 1:length(timCW)) {
    m[,i] <- distr * Aeff * exp(-(Aeff * timCW[i]))
  }
  
  ## return matrix with meaningful row and column names
  rownames(m) <- rprimes
  colnames(m) <- timCW
  m
}
#'@title Returns the sum CW-signal (model EST)
#'
#'@param ... parameters passed to [CWsignal] 
#'
#'@md
#'@export
stimIRSL <- function(...) {
  ## calculate CW signal
  temp <- CWsignal(...)
  
  ##extract dr steps from rownames
  dr <- diff(as.numeric(rownames(temp)[1:2]))[1]
  
  ## return IRSL signal normalised to the distance dr otherwise we 
  ## overestimate the values
  dr * colSums(temp)
}
#'@title Calculate distribution of r' values after a heating (model EST)
#'
#'@param Tph [numeric] (**required**): temperature to be heated 
#'
#'@param E [numeric] (**required**): trap depth in eV
#'
#'@param s [numeric] (**required**): frequency factor in 1/s
#'
#'@param rho [numeric] (**required**): dimensionless acceptor density
#'
#'@param rprimes [numeric] (**required**): r' vector 
#'
#'@param distr [numeric] (*optional*): distribution of r' values after treatment
#'
#'@return [matrix] with r' values (rows) and temperature values (columns)
#'
#'@md
#'@export
heatTo <- function(Tph, E, s, beta, rho, rprimes, distr = NULL) {
  ## define matrix
  m <- matrix(nrow = length(rprimes), ncol = length(Tph))
  rownames(m) <- rprimes
  colnames(m) <- Tph
  
  ##create new distribution if nothing is available 
  if (is.null(distr))
    distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
  
  ##set parameters
  Tph <- Tph + 273.15
  seff <- s * exp(-rprimes * (rho ^ (-1 / 3.0))) 
  
  ## calculate distributions
  for (i in 1:length(Tph)) {
  m[,i] <- distr * exp(-(seff * 8.617e-5 * Tph[i] ^ 2) /
                (beta[1] * E[1]) * exp(-E[1] / (8.617e-5 * Tph[i])) *
                (1 - 2 * 8.617e-5 * Tph[i] / E[1]))
    
  }
  m
}
#'@title Calculate r' values for a given preheat temperature and time (model EST)
#'
#'@param Tph [numeric] (**required**): preheat temperature in ˚C
#'
#'@param tph [numeric] (**required**): preheat time in s
#'
#'@param E [numeric] (**required**): trap depth in eV
#'
#'@param s [numeric] (**required**) frequency factor 1/s
#'
#'@param rho [numeric] (**required**): dimensionless acceptor density
#'
#'@param rprimes [numeric] (**required**): r' vector 
#'
#'@param distr [numeric] (*optional*): distribution of r' values after treatment
#'
#'@return [numeric] vector with new r' distribution for the given temperature
#'and preheat time
#'
#'@md
#'@export
heatAt <- function(Tph, tph, E, s, rprimes, distr = NULL) {
  ##create new distribution if nothing is available 
  if (is.null(distr)) distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
  
  seff <- s * exp(-rprimes * (rho ^ (-1 / 3.0))) 
  distr * exp(-(seff * exp(-E / (8.617e-5 * (Tph[1] + 273.15))) * tph[1]))
}

#'@title Evaluates and return TL signal for given temperatures (model EST)
#'
#'@param temp [numeric] (**required**): temperature vector 
#'
#'@param E [numeric] (**required**): trap depth in eV
#'
#'@param s [numeric] (**required**) frequency factor 1/s
#'
#'@param rho [numeric] (**required**): dimensionless acceptor density
#'
#'@param rprimes [numeric] (**required**): r' vector 
#'
#'@param distr [numeric] (*optional*): distribution of r' values after treatment
#'
#'@return [matrix] vector with TL signal for the given temperatures
#'
#'@md
#'@export
TLsignal <- function(temp, E, s, rho, rprimes, distr = NULL) {
  ##create new distribution if nothing is available 
  if (is.null(distr))
    distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
  
  ## define matrix
  m <- matrix(nrow = length(rprimes), ncol = length(temp))
  rownames(m) <- rprimes
  colnames(m) <- temp
  
  ##redefine parameters
  temp <- temp + 273.15
  seff <- s * exp(-rprimes * (rho ^ (-1 / 3.0))) 

  ##calculate
  for (i in 1:length(temp)) {
    m[,i] <- distr * seff * exp( -E / (8.617e-5 * temp[i])) * 
      exp(-(seff * 8.617e-5 * temp[i] ^ 2) / (beta * E) *
            exp(-E / (8.617e-5 * temp[i])) * (1 - 2 * 8.617e-5 * temp[i] / E))
    
  }
  m
}
#'@title Wrapper function to stimulate TL curves (model EST)
#'
#'@param ... parameters to passed to [TLsignal]
#'
#'@return [numeric] vector with the TL signal
#'
#'@md
#'@export
stimTL <- function(...) {
  ##calculate TL signal
  temp <- TLsignal(...)
  
  ##extract dr steps from rownames
  dr <- diff(as.numeric(rownames(temp)[1:2]))[1]
  
  dr * colSums(temp)
}                     
#'@title  Irradiation over time at a fixed temperature (TA-EST)
#'
#'@param Tirr [numeric] (**required**): irradiation temperature in ˚C. Only a single value
#'is allowed
#'
#'@param tirr [numeric] (**required**): irradiation time in s
#'
#'@param E [numeric] (**required**): trap depth in eV
#'
#'@param s [numeric] (**required**) frequency factor 1/s
#'
#'@param rho [numeric] (**required**): dimensionless acceptor density
#'
#'@param rprimes [numeric] (**required**): r' vector 
#'
#'@param D0 [numeric] (**required**): D naught, the saturation level parameter in Gy
#'
#'@param Ddot [numeric] (**required**): the external dose rate in Gy/ka
#'
#'@param dist [numeric] (*optional*): distribution of r'
#'
#'@return [matrix] with r' values (rows) and irradiation times (columns)
#'
#'@md
#'@export
irradandThermalfortimeT <- function(Tirr, tirr, E, s, rho, rprimes, D0, Ddot, distr = NULL) {
  ##create new distribution if nothing is available 
  if (is.null(distr))
    distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
  
  ## define matrix
  m <- matrix(nrow = length(rprimes), ncol = length(tirr))
  rownames(m) <- rprimes
  colnames(m) <- tirr
  
  ## calculate parameters
  Tirr <- Tirr[1] + 273.15
  seff <- s[1] * exp(-rprimes * (rho[1] ^ (-1 / 3.0)))  
  Peff <- (1 / (1 / s + 1 / seff)) * exp(-E[1] / (8.617e-5 * Tirr[1]))
  
  ## calculate new distribution
  for (i in 1:length(tirr)) {
    m[, i] <-
      distr * (Ddot * rprimes / (D0 * Peff + Ddot[1])) * 
      (1 - exp(-(Ddot[1] / D0[1] + Peff) * tirr[i]))
  }
  m

}
#'@title Irradiation for a fixed time for different temperatures (TA-EST)
#'
#'@param Tirr [numeric] (**required**): irradiation temperatures in ˚C
#'
#'@param tirr [numeric] (**required**): irradiation time in s. Only a single value
#'is allowed
#'
#'@param E [numeric] (**required**): trap depth in eV
#'
#'@param s [numeric] (**required**) frequency factor 1/s
#'
#'@param rho [numeric] (**required**): dimensionless acceptor density
#'
#'@param rprimes [numeric] (**required**): r' vector 
#'
#'@param D0 [numeric] (**required**): D naught, the saturation level parameter in Gy
#'
#'@param Ddot [numeric] (**required**): the external dose rate in Gy/ka
#'
#'@param dist [numeric] (*optional*): distribution of r'
#'
#'@return [matrix] with r' values (rows) and irradiation temperatures (columns)
#'
#'@md
#'@export
irradatsometemp <- function(Tirr, tirr, E, s, rho, rprimes, D0, Ddot, distr = NULL) {
  ##create new distribution if nothing is available 
  if (is.null(distr))
    distr <- 3 * rprimes ^ 2 * exp(-rprimes ^ 3)
  
  ## define matrix
  m <- matrix(nrow = length(rprimes), ncol = length(Tirr))
  rownames(m) <- rprimes
  colnames(m) <- Tirr
  
  ## calculate parameters
  Tirr <- Tirr + 273.15
  seff <- s[1] * exp(-rprimes * (rho[1] ^ (-1 / 3)))  

  ## calculate the distribution
  for (i in 1:length(Tirr)) {
   Peff <- (1 / (1 / s[1] + 1 / seff)) * exp(-E[1] / (8.617e-5 * Tirr[i]))
   m[,i] <- distr *
      (Ddot[1] * rprimes / (D0[1] * Peff + Ddot[1])) * 
     (1 - exp(-(Ddot[1] / D0[1] + Peff) * tirr[1]))
  }
  m
}