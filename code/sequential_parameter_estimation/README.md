# Lumped Parameter Linear Superposition (LPLSP) based reduced order model (ROM) using sequential parameter estimation
An implementation of Lumped Parameter Linear Superposition (LPLSP) methods for transient thermal system modeling.

## Sequential Parameter Estimation and Modeling
Traditional LPLSP implementation requiring sequential excitation of individual heat sources.

Located in:\
[1 Isolated Body](/code/sequential_parameter_estimation/Matlab/1-Body) \
[2 Body Conduction](/code/sequential_parameter_estimation/Matlab/2-Body) \
[Convection](/code/sequential_parameter_estimation/Matlab/Convection) \
[ECU Simulation (Multibody mixed mode heat transfer)](/code/sequential_parameter_estimation/Matlab/Multibody) 

### Model and Code
Within each folder, there are excel sheets containing the inputs for the simulation as well as the temperature measured from the simulation for the input. The corresponding Ansys Icepak simulation files (compressed .tzr projects are available in [Icepak Simulation Files](/data/simulations). The MATLAB code then imports the temperatures from the Excel sheet, performs optimization and estimates the model parameters. The MATLAB function within each folder then calculates the temperature response for new input power dissipation via LPLSP. 



