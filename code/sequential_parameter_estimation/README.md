\# Lumped Parameter Linear Superposition (LPLSP) based reduced order model (ROM) using sequential parameter estimation



An implementation of Lumped Parameter Linear Superposition (LPLSP) methods for transient thermal system modeling.



\## Overview



For general multibody systems involving both conduction and convection heat transfer modes, the model constants are estimated by the following process,

1\. A parametric CFD simulation is performed by applying 1W of input power to one MOSFET junction while keeping the inputs of the other MOSFETs as 0 W. The simulation is run for a short duration (t ≈ 10 s with dt ≈ 0.2 s), since the power dissipation for highly transient power electronics systems typically vary at a rate of 100 − 1000µs. The temperatures of all six MOSFETs (sources), the PCBA and the heatsink are recorded. This process is repeated for each individual heat source. Thus, the number of trials equals the number of sources present in the system.

2\. For each trial run, the characteristic thermal resistances and time constants for each component are determined by minimizing the sum of squared errors SSE = \\sum\_i (T\_s\_i(t) − T\_i(t))^2 between the temperature difference measured from the simulation T\_s(t) and the temperature predicted by the model T\_i(t). A generalized reduced gradient optimization method is used to estimate the parameters that minimize the SSE.

3\. In Trial 1, the effect of MOSFET 1 on all other MOSFETs, the PCBA, and the heatsink is obtained. For example, R11 represents the thermal resistance measured at MOSFET 1 when power is applied at MOSFET 1, while R31 represents the thermal resistance measured at MOSFET 3 under the same input condition. In trial 2, the influence of MOSFET 2 on all other components is computed, and so on.

4\. To compute the temperature of MOSFET 1 considering all heat sources, the superposition of contributions from each source is used as, T1 = T0+P1(t)\*R11\*\[1−e^{−K11\*t}] +P2(t)\*R12\*\[1 − e^{-K12\*t}]+P3(t)\*R13\[1 − e^{-K13\*t}] + P4(t)\*R14\*\[1 − e^{−K14\*t}]+ P5(t)\*R15\*\[1 − e^{−K15\*t}] + P6(t)\*R16\*\[1 − e^{−K16\*t}]. A similar approach is used for all the other components.

5\. For forced convection systems with variable flow velocity, the parametric simulations described in Step 1 must be extended to account for variations in flow velocity. The modified parametric simulations are defined as, 

• P1(t) = 1,P2(t),...,P6(t) = 0,Uf = 1

• P1(t) = 1,P2(t),...,P6(t) = 0,Uf = 5

• P1(t) = 1,P2(t),...,P6(t) = 0,Uf = 10

• P1(t) = 1,P2(t),...,P6(t) = 0,Uf = 20

The same set of velocity conditions is applied for each heat source. Therefore, for 6 sources and 4 velocity magnitudes, a total of 24 simulations are required.



\## Contents



\### Sequential Parameter Estimation and Modeling



Traditional LPLSP implementation requiring sequential excitation of individual heat sources.



Located in:



LPLSP - Lumped Parameter Linear Superposition\\code\\sequential\_parameter\_estimation\\1-Body

LPLSP - Lumped Parameter Linear Superposition\\code\\sequential\_parameter\_estimation\\2-Body

LPLSP - Lumped Parameter Linear Superposition\\code\\sequential\_parameter\_estimation\\Convection

LPLSP - Lumped Parameter Linear Superposition\\code\\sequential\_parameter\_estimation\\Multibody



\### Model and Code



Within each folder, there is a packed Ansys Icepak (thermal simulation - CFD) project (.tzr). The attached excel sheet contains the inputs for the simulation as well as the temperature measured from the simulation for the input. The MATLAB code then imports the temperatures from the Excel sheet, performs optimization and estimates the model parameters. The MATLAB function within each folder then calculates the temperature response for new input power dissipation via LPLSP. 



