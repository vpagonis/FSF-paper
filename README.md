# FSF-paper

This repository contains all the R scripts from the paper:


**Simulating feldspar luminescence phenomena using R**
by Vasilis Pagonis, Christoph Schmidt, Sebastian Kreutzer**

**Submitted to Journal of Luminescence**

**January 2021**

__________________________________

**ABSTRACT**

Abstract Kinetic models have been used extensively for modeling and numerical simulation of luminescence phenomena and dating techniques in a variety of dosimetric materials. While several comprehensive models have been implemented for quartz, there are no such comprehensive models implemented for feldspars. In this paper we introduce the open-access R scripts Feldspar Simulation Functions (FSF), for kinetic model simulation of luminescence phenomena in feldspars. Several compact and flexible functions are designed to simulate events in the geological history of feldspars: irradiation, optical illumination, and heating processes. These R functions provided by FSF offer useful numerical tools to perform luminescence simulations in a user friendly manner. The mathematical framework of four different types of previously published models is presented in a uniform manner, and the models are simulated with FSF. While previously published versions of these four models require numerical integration of the differential equations, FSF circumvent the need for numerical integration by using accurate summations over the finite range of the model parameters. The simulation process can be understood easily by creating transparent sequences of events, consisting of these compact R functions. Several practical examples are provided of using the FSF to simulate the geological history, as well as the laboratory treatments of feldspar samples. The key physical concept in FSF is that irradiation, thermal and optical treatments of feldspars change the distribution of nearest neighbor (NN) distances in donor-acceptor pairs. These changes are described using analytical equations within the four models examined in this paper. 
The NN distribution at the end of one simulation stage, becomes the initial distribution for the next stage in the sequences of events being simulated.

__________________________________
**HOW THE R CODES ARE ORGANIZED**

The repository contains the 13 R scripts which were used to rpoduce the figures in the paper.
These scripts are self contained and ready to run. 
__________________________________

**DATA FILES USED BY THE R CODES**

The folders  contains also some data files (.txt or .asc format):
_lbodata.txt_
_lbodata.txt_

These data files are used by some of the R scripts, so they should  be placed in the appropriate working directory.

For example,  _Chapter 2 folder_ contains the file

   

which is used by some of the codes in Chapter 2.

__________________________________

**GENERAL INFORMATION ABOUT THE R CODES**

I have kept the number of required external R packages intentionally
at a minimum, so that newcomers to R can follow the R codes easily.

All figures in this book were produced using the R scripts in this repository, so that
users know immediately what to expect when they run the scripts. 

Experienced programmers of R will quickly find out that they can improve
the R codes given here, and it is of course possible to make the codes
more compact and elegant. However, I chose to provide R codes which are
simple and clear, and which can be easily modified for the purposes of the
reader, rather than attempting to create compact codes which may be difficult
to follow and modify. 

Several chapters are dedicated to Monte Carlo (MC) methods, which are used to simulate the luminescence processes during
the irradiation, heating and optical stimulation of solids, for a wide variety
of materials. 
Throughout the book, both localized and delocalized transition luminescence
models are simulated using the new R-package **_RLumCarlo_**.

I hope you will find the scripts useful and that you will enjoy running and modifying the various files.
If you find that some script is not clear or has inaccuracies, kindly let me know at
_vpagonis@mcdaniel.edu_

Enjoy!

Vasilis Pagonis

Professor of Physics Emeritus

McDaniel College, USA
