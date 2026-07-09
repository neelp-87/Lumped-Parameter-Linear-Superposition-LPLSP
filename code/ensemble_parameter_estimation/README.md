# Ensemble Parameter Estimation applied to Lumped Parameter Linear Superposition method
An implementation reduced order model (ROM) of a thermal system via Ensemble Parameter Estimation applied to Lumped Parameter Linear Superposition method

# Overview:
This code maps the heat generated at source (Watt) within the system to the temperature reponse $(\textdegree C)$ at any location within the system. It works seamlessly for a system with many sources and many monitor points, which may be present on the source or away from the source.

# Model description
This model works in two stages:

1. Training - In this stage, the algorithm learns various parameters that physically relate the heat dissipated at the source (input) to the temperature response at a monitor point (output).
    
1.1. This model reduces a thermal system to lumped parameters (thermal resistance $R$ - physically represents a component's resistance to heat flow, thermal capacitance $C$ - physically represents a component's ability to store heat, and time constant $K = 1/RC$.

1.2. It relates the heat loss in an electronic component (input power dissipation in Watts) to spatial temperature change (for example temperature within the component or on the case or at a location on the PCBA in degree C) using equation:
```math
T_{i}(t) = T_{0} + \sum_{j=1} ^{N} \sum_{m} \Delta(P_{j}(t)*R_{ij})_{m} *(1-e^{-K_{ij}*(t-t_{m})})
```
where, $j$ is the number of heat sources and m is the index of change of input.

1.3. The terms $R\_{ij}$ (thermal resistance matrix) and $K\_{ij}$ (time constant matrix) generally require several sequential simulations, where a unit input power (1W) is applied to each source and the temperature response of all the monitor points are measured. Then a superposition matrix is created.

1.4. However, in this case instead of sequential simulations, a single transient simulation is run where all the heat sources are excited at the same time and all the temperature monitor points are measured. Then a parameter matrix for $R,K$ that map output $T$ to input $P$ are estimated simultaneously.

1.5. Once estimated, the parameter matrices R,K are saved.

2. Testing / Prediction - In this stage, the algorithm uses the saved parameters (representation of the full system) to predict temperature response for new input power dissipations. 
This approach is very efficient because it reduces not only the the time required to predict temperature of a thermal system for new unseen inputs, but also reduces the time required to create the reduced order model which is a major bottleneck for large systems.

# Limitations and Improvements
This approach is generally applicable to any thermal system where conduction and convection modes dominate the heat transfer. However, extension to other systems will require careful review of the system (sources and sinks), units of heat generation, temperature response

and the dominant modes of heat transfer. While this approach can be expanded to non-linear convection (convection with variable flow velocities) and radiation, this code as is does not model these cases accurately. A separate code for the non-linear cases will be posted.


# SUMMARY OF THE CODE: 
This script identifies thermal coupling parameters between multiple power sources and multiple temperature sensors.

## Model:
Temperature = Sum of first-order thermal responses to input power changes.
### Parameters estimated:
$R$: thermal resistance matrix
$K$: time constant matrix

In most thermal systems $R, K$ matrices have a structure where the nearby sensors behave similarly and thermal paths are correlated. So even if we have 6 sources and 8 monitor points, which leads to 48 + 48 = 96 total parameters, the number of effective parameters for actual heat transfer physics are usually smaller. Hence to reduce parameter count we decompose the matrices $R,K$ into matrices $A, B, C$ and $D$ where:
```math
R = A B^T 
K = C D^T
```
where, $A$ and $C$ are matrices of size $[n\_{temps} \times r]$, $B$ and $D$ are matrices of size $[n\_{inputs} \times r]$ and $r$ is the rank of the matrix. From experiments it is determined that even a rank $r=1$, creates a good response and rank $r=3$ creates a ROM as good as full rank matrices.

### Optimizer:
scipy.optimize.least\_squares()

### Input file:
Training.xlsx
Data Format: Training data arranged in columns labeled $t, P\_j, T\_i$

### Output file:
parameters_rank_reduced.xlsx


# References
Complete description of this approach is presented in the following papers. [Author accepted manuscripts (AAM) are posted in] (publications\papers_and_preprints).
## Background of the method, derivation and case studies 
1. N. Padmanabhan, "A Transient Thermal Model for Power Electronics Systems," SoutheastCon 2024, Atlanta, GA, USA, 2024, pp. 1294-1299, doi: 10.1109/SoutheastCon52093.2024.10500091.
2. Padmanabhan, N., "A Scalable Approach for Transient Thermal Modeling of Automotive Power Electronics," SAE Technical Paper Series, January 1, 2025, https://doi.org/10.4271/2025-01-5073.

## Ensemble parameter estimation method, algorithm and case studies
1. Padmanabhan, N., "Rapid Modeling of Transient Thermal Systems through Ensemble Parameter Estimation Applied to the Lumped Parameter Linear Superposition Method," SAE Technical Paper Series, January 1, 2026, https://doi.org/10.4271/2026-01-5034.
