# CFD Thermal Simulation
The simulation setup described here is used to generate the full CFD data, training data for model development, and to calculate computational times. 
The case studies considered in this work include:

(1) [one body isolated system](/code/sequential_parameter_estimation/Matlab/1-Body),\
(2) [two-body conduction system](/code/sequential_parameter_estimation/Matlab/2-Body),\
(3) [three-body natural convection system](/code/sequential_parameter_estimation/Matlab/Convection), and\
(4) [an inverter module](/code/ensemble_parameter_estimation/Python/Source_PowerDissipation_Only/) comprising six MOSFETs mounted on a printed circuit board assembly (PCBA) attached to a finned heatsink under natural convection and forced convection environment at constant flow velocity.

<p align="center">
<img src="/data/simulation/T_component.png" width="600">
</p>

These configurations represent a broad class of thermal management problems encountered in automotive and industrial electronics, ranging from simple conduction-dominated assemblies to complex multi-source systems with coupled conduction and convection. All simulations were performed using Ansys® Icepak™. The solver computes the incompressible Navier–Stokes and energy equations with buoyancy modeled via the Boussinesq approximation for natural convection, while applying ideal gas equation of state for forced convection. A zero-order turbulence model was employed, with first- and second-order upwind schemes for spatial discretization and a fully implicit scheme for temporal integration. Initial conditions were set to $20 ^{\circ}$ and $1 atm$, with standard earth gravity. Open boundary conditions were applied for natural convection and inlet velocity of $U = 10 m/s$ is applied for forced convection. Material properties for silicon, copper, FR4, and aluminum were assigned based on manufacturer data to ensure accurate thermal conduction paths. Mesh resolution was selected through a grid-independence study, with total cell counts ranging from $3 \times 10^5$ to $3 \times 10^6$ depending on geometry complexity. Grid stretching and clustering were applied near heat sources and critical flow regions, while non-conformal meshing allowed separate refinement of PCBA and heatsink assemblies. Cut-cell meshing was used to preserve geometric fidelity. These settings ensured convergence of flow and energy equations under the solver’s default criteria.

Compressed versions of the Icepak files (.tzr), along with the raw input and output data in Excel format (.xlsx) are included for each use case.
