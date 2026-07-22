# Lumped Parameter Linear Superposition (LPLSP) based reduced order model (ROM) using sequential parameter estimation
An implementation of Lumped Parameter Linear Superposition (LPLSP) methods for transient thermal system modeling.

## Sequential Parameter Estimation and Modeling
Traditional LPLSP implementation requiring sequential excitation of individual heat sources.

Located in:\
[/code/sequential_parameter_estimation/Matlab](/code/sequential_parameter_estimation/Matlab/1-Body)\
[/code/sequential_parameter_estimation/Matlab](/code/sequential_parameter_estimation/Matlab/2-Body)\
[/code/sequential_parameter_estimation/Matlab](/code/sequential_parameter_estimation/Matlab/Convection)\
[/code/sequential_parameter_estimation/Matlab](/code/sequential_parameter_estimation/Matlab/Multibody)

### Model and Code
Within each folder, there is a packed Ansys Icepak (thermal simulation - CFD) project (.tzr). The attached excel sheet contains the inputs for the simulation as well as the temperature measured from the simulation for the input. The MATLAB code then imports the temperatures from the Excel sheet, performs optimization and estimates the model parameters. The MATLAB function within each folder then calculates the temperature response for new input power dissipation via LPLSP. 



