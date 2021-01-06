# FSF-paper

This repository contains all the R scripts from the paper:


**Simulating feldspar luminescence phenomena using R**


by Vasilis Pagonis, Christoph Schmidt, Sebastian Kreutzer

**Submitted to the Journal of Luminescence**

**January 2021**


__________________________________
**HOW THE R SCRIPTS ARE ORGANIZED**

The repository contains the 13 R scripts which were used to produce the figures in the paper.

These scripts are self contained and ready to run.

The scripts use the R file containing the FSF:

- Functions_FSFpaper.R 

The FSF are loaded at the beginning of the scripts, with the command:

- source("Functions_FSFpaper.R") 
__________________________________

**DATA FILES USED BY THE R CODES**

The folders  contains also two data files (.txt or .asc format):

_ph300s0IR.asc_

which contains the CW-IRSL data analyzed in Figure 13,

and the file

_ph300s0.asc_


which contains the TL data analyzed in Figure 14.

These data files  must be placed in the appropriate working directory.
__________________________________

**ABSTRACT**

 Kinetic models have been used extensively for modeling and numerical simulation of luminescence phenomena and dating techniques in a variety of dosimetric materials. While several comprehensive models have been implemented for quartz, there are no such comprehensive models implemented for feldspars. In this paper we introduce the open-access R scripts Feldspar Simulation Functions (FSF), for kinetic model simulation of luminescence phenomena in feldspars. Several compact and flexible functions are designed to simulate events in the geological history of feldspars: irradiation, optical illumination, and heating processes. These R functions provided by FSF offer useful numerical tools to perform luminescence simulations in a user friendly manner. The mathematical framework of four different types of previously published models is presented in a uniform manner, and the models are simulated with FSF. While previously published versions of these four models require numerical integration of the differential equations, FSF circumvent the need for numerical integration by using accurate summations over the finite range of the model parameters. The simulation process can be understood easily by creating transparent sequences of events, consisting of these compact R functions. Several practical examples are provided of using the FSF to simulate the geological history, as well as the laboratory treatments of feldspar samples. The key physical concept in FSF is that irradiation, thermal and optical treatments of feldspars change the distribution of nearest neighbor (NN) distances in donor-acceptor pairs. These changes are described using analytical equations within the four models examined in this paper. 
The NN distribution at the end of one simulation stage, becomes the initial distribution for the next stage in the sequences of events being simulated.

