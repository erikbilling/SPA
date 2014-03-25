
SPA - A neural dynamic framework for Simultaneous Planning and Action
=====================================================================

This project is based on Dynamic Field Theory (DFT). DFT is a mathematical formulation
of neural behavior at the population level, used to model various perceptual, motor, and
cognitive functions. 

DFT is here used to form attractor patterns representing a sequence of actions towards a 
goal. These dynamic plans can handle temporary occlusions, very high level of noise and 
continuously update as conditions in the environment change. 

Two example implementations are provided with this project:

1.	A disembodied agent moving around on a 2D surface, finding its way from start to goal.
	This simulation runs completely within MATLAB. 
2.	A controller for an E-Puck miniature robot, simulated in Webots. This example depends
	on MATLAB, Webots, and Python. 

This implementation has been used to evaluate the *SPA* framework, please refer to 
Billing et al. (submitted) for more details and background on the theory. 

Prerequisites
-------------

First of all, we recommend that you download *SPA* and other dependent projects by 
checking out the code directly from the repository. For this, you'll need 
[Mercurial](http://mercurial.selenic.com/) installed.

The main parts of *SPA* is implemented in [MATLAB](http://www.mathworks.se/products/matlab/). 
*SPA* is tested on 64bit MATLAB 2013a, 2013b, and 2014a, under Linux and OS X, but should 
work also on other versions of MATLAB. Please refer to the [Cosivina documentation](https://bitbucket.org/sschneegans/cosivina) 
for further details on compatibility with other MATLAB versions. 

Some parts of *SPA* also requires the following software:
* [Cyberbotics Webots Pro](http://www.cyberbotics.com/) 7.4 (Unfortunately, the free version of Webots does not work) 
* [Python](https://www.python.org/)

**Note** that there are some limitations in the compatibility between MATLAB and Webots, 
please refer to the [Webots Documentation](http://www.cyberbotics.com/) for details. 

Setup
-----

Stary by checking out the source code for *SPA* into a folder of your choice, for example
*~/Documents/MATLAB/Spa*, using the following command:

	hg clone https://bitbucket.org/interactionlab/spa ~/Documents/MATLAB/Spa

*SPA* depends on [Cosivina](https://bitbucket.org/sschneegans/cosivina). By default, *SPA*
will look for *Cosivina* in *../Cosivina/*, relative to the location where you checked out 
*SPA*. We therefore recommend that you check out *Cosivina* into 
*~/Documents/MATLAB/Cosivina*:

	hg clone https://bitbucket.org/sschneegans/cosivina ~/Documents/MATLAB/Cosivina

You may also want to install [JSONlab](http://sourceforge.net/projects/iso2mesh/files/jsonlab/). 
This is not required for the core functionality of *SPA* but used by *Cosivina* to store 
user preferences. Please refer to the [Cosivina documentation](https://bitbucket.org/sschneegans/cosivina) 
for details.

Now start MATLAB, navigate to the *SPA* root directory and and initiate the framework by 
running *setpath*: 

	>> setpath
	
If you use a custom location for *Cosivina*, specify that as the first argument to 
*setpath*:

	>> setpath /My/Cosivina/Dir
	
The *setpath* script registers temporary directories in the MATLAB path, and will need to
be reexecuted after you restart MATLAB.
	
Run
---

### Example 1

This example implements a disembodied agent moving around on a 2D surface, finding its way 
from start to goal.	This simulation runs completely within MATLAB and may be executed
with the following command:

	>> launcherContinuousSearch

This launcher should bring up a window with six plots and some controls at the bottom. 
For further explanations of this simulation, please refer to the __SpaDocumentation.pdf__ 
provided with this package.

### Example 2

This example runs through Webots and comprise a simulated E-Puck robot finding its way 
from a random start location to the goal, in a simple maze environment. The example is 
executed by opening the Webots world file *e-puck-fieldsearch.wbt* located in
*~/Documents/MATLAB/Spa/webots/epuck/worlds*, (assuming that you placed *SPA* in 
*~/Documents/MATLAB/Spa*. 

When the simulation runs you'll see a plot window similar to the one in *Example 1*. For 
further explanations of this simulation, please refer to the __SpaDocumentation.pdf__ 
provided with this package. 


References

----------


E. A. Billing, Robert Lowe, and Yulia Sandmirskaya. Simultaneous Planning and Action: 
Neural-dynamic Sequencing. Submitted to Paladyn, Journal of Behavioral Robotics. Versita. 
2014. 