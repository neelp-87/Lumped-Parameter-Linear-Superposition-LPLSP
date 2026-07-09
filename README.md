# Lumped Parameter Linear Superposition (LPLSP) based reduced order model (ROM)
An implementation of Lumped Parameter Linear Superposition (LPLSP) methods for transient thermal system modeling.

## Overview
LPLSP is a reduced-order modeling technique that combines lumped parameter thermal modeling with linear superposition. It maps heat generation within an electronic system to temperature response at arbitrary monitor locations.

The method is intended for systems with:

* Multiple heat sources and sinks
* Multiple temperature monitor points
* Transient operating conditions
* Conduction, natural convection or forced convection dominated heat transfer modes

The resulting model can rapidly predict temperature response while preserving the dominant thermal dynamics of the original system.

## Applicable Physics
The thermal system is represented using lumped thermal parameters:

- Thermal Resistance $(R)$
- Thermal Capacitance $(C)$
- Time Constant $(K = 1/RC)$

The temperature response is modeled through linear superposition of source contributions and expressed in a compact form as,

$$
T_i(t)=T_0+
\sum_{j=1}^{N}
\sum_{m}
\Delta\left(P_j(t)R_{ij}\right)_m
\left(
1-e^{-K_{ij}(t-t_m)}
\right)
$$


## Repository Contents
### Theory
Background, formulation and development of the model.

[Theory](/docs/theory.md)

### Algorithm
Algorithm of the model. This includes 1. Algorithm for sequential parameter estimation, 2. Algorithm for ensemble parameter estimation (single shot estimation) from transient data.

[Algorithm](/docs/algorithm.md)

### Codes
#### Sequential Parameter Estimation and Modeling
Traditional LPLSP implementation requiring sequential excitation of individual heat sources.

[Base_Code](/code/sequential_parameter_estimation)


#### Ensemble Parameter Estimation and Modeling
LPLSP model parameters estimated using a short single transient simulation data, reducing the overall computation time for ROM development and temperature estimation using ROM.

[Fast_Code](/code/ensemble_parameter_estimation)

### Publications
Author-accepted manuscripts of the papers that present the model's background, theory, formulation, algorithms, case studies as well as a sensitivity analysis of the physical parameters in the model. 

**Location:** publications/papers_and_preprints

## References
If you use this repository in academic research, please cite the following publications:
### [1] Background Methodology
N. Padmanabhan, "A Transient Thermal Model for Power Electronics Systems," SoutheastCon 2024, Atlanta, GA, USA, 2024, pp. 1294-1299, doi: 10.1109/SoutheastCon52093.2024.10500091.

### [2] Background, expanded case studies and sensitivity studies
Padmanabhan, N., "A Scalable Approach for Transient Thermal Modeling of Automotive Power Electronics," SAE Technical Paper Series, January 1, 2025, https://doi.org/10.4271/2025-01-5073.

### [3] Ensemble Parameter Estimation to improve overall speed of ROM development and computation speed of ROM for new unseen inputs
Padmanabhan, N., "Rapid Modeling of Transient Thermal Systems through Ensemble Parameter Estimation Applied to the Lumped Parameter Linear Superposition Method," SAE Technical Paper Series, January 1, 2026, https://doi.org/10.4271/2026-01-5034.

