\# Lumped Parameter Linear Superposition (LPLSP) based reduced order model (ROM)



An implementation of Lumped Parameter Linear Superposition (LPLSP) methods for transient thermal system modeling.



\## Overview



LPLSP is a reduced-order modeling technique that combines lumped parameter thermal modeling with linear superposition. It maps heat generation within an electronic system to temperature response at arbitrary monitor locations.



The method is intended for systems with:



* Multiple heat sources and sinks
* Multiple temperature monitor points
* Transient operating conditions
* Conduction, natural convection or forced convection dominated heat transfer modes



The resulting model can rapidly predict temperature response while preserving the dominant thermal dynamics of the original system.



\## Applicable Physics



The thermal system is represented using lumped thermal parameters:



\- Thermal Resistance (R)

\- Thermal Capacitance (C)

\- Time Constant (K = 1/RC)



The temperature response is modeled through linear superposition of source contributions.



\## Repository Contents



\### Sequential Parameter Estimation and Modeling



Traditional LPLSP implementation requiring sequential excitation of individual heat sources.



Located in:



LPLSP - Lumped Parameter Linear Superposition\\code\\sequential\_parameter\_estimation



\### Ensemble Parameter Estimation and Modeling



LPLSP model parameters estimated using a short single transient simulation data, reducing the overall computation time for ROM development and temperature estimation using ROM



Located in:



LPLSP - Lumped Parameter Linear Superposition\\code\\ensemble\_parameter\_estimation



\# Citation



If you use this repository in academic research, please cite the following publications:



\## \[1] Background Methodology



N. Padmanabhan, "A Transient Thermal Model for Power Electronics Systems," SoutheastCon 2024, Atlanta, GA, USA, 2024, pp. 1294-1299, doi: 10.1109/SoutheastCon52093.2024.10500091.



DOI:

https://doi.org/10.1109/SoutheastCon52093.2024.10500091



\## \[2] Background, expanded case studies and sensitivity studies



Padmanabhan, N., "A Scalable Approach for Transient Thermal Modeling of Automotive Power Electronics," SAE Technical Paper Series, January 1, 2025, https://doi.org/10.4271/2025-01-5073.



DOI:

https://doi.org/10.4271/2025-01-5073



\## \[3] Ensemble Parameter Estimation to improve overall speed of ROM development and computation speed of ROM for new unseen inputs



Padmanabhan, N., "Rapid Modeling of Transient Thermal Systems through Ensemble Parameter Estimation Applied to the Lumped Parameter Linear Superposition Method," SAE Technical Paper Series, January 1, 2026, https://doi.org/10.4271/2026-01-5034.



DOI:

https://doi.org/10.4271/2026-01-5034

