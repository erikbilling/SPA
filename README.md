
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
[Billing et. al (submitted)][SPA] for more details and background on the theory. 

[SPA]: http://www.degruyter.com/view/j/pjbr E. A. Billing, Robert Lowe, and Yulia Sandmirskaya. Simultaneous Planning and Action: Neural-dynamic Sequencing. Submitted to Paladyn, Journal of Behavioral Robotics. Versita. 2014. 