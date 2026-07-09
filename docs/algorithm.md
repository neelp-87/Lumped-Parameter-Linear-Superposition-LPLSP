# Overview
Three algorithms are presented here. 
1. Estimation of parameters $R\_{ij}$, $K\_{ij}$ sequentially from multiple simulation runs
2. Estimation of parameters $R\_{ij}$, $K\_{ij}$ from a single transient simulation dataset - Naive Implementation
3. Estimation of parameters $R\_{ij}$, $K\_{ij}$ from a single transient simulation dataset - Rank Reduction method

## Estimation of parameters $R\_{ij}$, $K\_{ij}$ sequentially from multiple simulation runs
For general multibody systems involving both conduction and convection heat transfer modes, the model constants are estimated by the following process:
1. A parametric CFD simulation is performed by applying 1W of input power to one MOSFET junction while keeping the inputs of the other MOSFETs as 0 W. The simulation is run for a short duration $(t_s \approx 10 s, \Delta t \approx 0.2 s$), since the power dissipation for highly transient power electronics systems typically vary at a rate of $100-1000 \mu s$. The temperatures of all six MOSFETs (sources), the PCBA and the heatsink are recorded. This process is repeated for each individual heat source. Thus, the number of trials equals the number of sources present in the system. 
2. For each trial run, the characteristic thermal resistances and time constants for each component are determined by minimizing the sum of squared errors $\bigl[SSE =\sum_i \bigl((T^{s} _i (t)-T^L(t)) - T_i(t) \bigr)^2 \bigr]$ between the temperature difference measured from the simulation and the linear temperature curve $T^{s}_i-T^L(t)$ and the temperature predicted by the model $T_i(t)$. A generalized reduced gradient optimization method is used to estimate the parameters that minimize the $SSE$. 
3. In Trial 1, the effect of MOSFET 1 on all other MOSFETs, the PCBA, and the heatsink is obtained. For example, $R_{11}$ represents the thermal resistance measured at MOSFET 1 when power is applied at MOSFET 1, while $R_{31}$ represents the thermal resistance measured at MOSFET 3 under the same input condition. In trial 2, the influence of MOSFET 2 on all other components is computed, and so on. 
4. To compute the temperature of MOSFET 1 considering all heat sources, the superposition of contributions from each source is used as,
```math
\begin{aligned}
T_1 = T^0 + T^L(t) + P_1(t) R_{11} [1-e^{-\theta_{1} t}] + P_2(t) R_{12} [1-e^{-\theta_{2} t}] + \\ 
P_3(t) R_{13} [1-e^{-\theta_{3} t}] +  P_4(t) R_{14} [1-e^{-\theta_{4} t}] + \\
P_5(t) R_{15} [1-e^{-\theta_{5} t}] +  P_6(t) R_{16} [1-e^{-\theta_{6} t}].
\end{aligned}
```
A similar approach is used for all the other components. 
5. For forced convection systems with variable flow velocity, the parametric simulations must be extended to account for variations in flow velocity. The modified parametric simulations are defined as,

a. $P\_1 (t)=1, P\_2(t), \ldots, P\_6(t)=0, U\_f=1$

b. $P\_1 (t)=1, P\_2(t), \ldots, P\_6(t)=0, U\_f=5$ 

c. $P\_1 (t)=1, P\_2(t), \ldots, P\_6(t)=0, U\_f=10$

d. $P\_1 (t)=1, P\_2(t), \ldots, P\_6(t)=0, U\_f=20$

The same set of velocity conditions is applied for each heat source. Therefore, for 6 sources and 4 velocity magnitudes, a total of 24 simulations are required. Case studies for natural convection, and forced convection using this algorithm can be found in [^SAE1]. As evident, this process can be long, time consuming and involve a large number of optimizations to determine all the parameters. While the resulting ROM will be fast and accurate, the process of ROM development itself is very slow and for very large systems may defeat the purpose of ROM development. 

## Estimation of parameters $R\_{ij}$, $K\_{ij}$ from a single transient simulation dataset - Naive Implementation
Instead of running individual parametric studies for each source, a single simulation can be performed in which arbitrary transient or pseudo-random power dissipation inputs $P_1(t)$ and $P_2(t)$ can be applied to the two bodies in a simulation and the resulting temperature response $T_1(t)$ and $T_2(t)$ can be recorded. Given the measured outputs $T_i(t)$, the inputs $P_j(t)$, and the LPLSP model equation, the only unknown parameters are the four thermal resistances $(R_{11}, R_{12}, R_{21}, R_{22})$ and the four time constants $(K_{11}, K_{12}, K_{21}, K_{22})$. Numerical experiments indicated that the nonlinear least-squares optimizer used in traditional approach, is capable of recovering all model coefficients even when multiple sources are excited simultaneously using arbitrary transient inputs. This insight suggested that a single-shot identification procedure was feasible. Since all the parameters are inferred together from one dataset, this strategy is referred to as ensemble parameter estimation. This results in a substantial reduction in computational effort and overall model development time. Once the parameters are identified, they are substituted back into the model equation, enabling rapid prediction of temperatures for new input power dissipation profiles.
A pseudocode for this can be found in the following work [^SAE2]. The code for Naive implementation of ensemble parameter estimation for LPLSP model is located in the **Location:** code/sequential_parameter_estimation

## Estimation of parameters $R\_{ij}$, $K\_{ij}$ from a single transient simulation dataset - Rank Reduction method
This approach is conceptually similar to Proper Orthogonal Decomposition (POD) [^POD] or Principal Component Analysis (PCA), where a high-dimensional system is efficiently represented using a small number of dominant modes. In this context, the matrices $R$ and $K$ act as spatial coupling operators between the heat sources and the temperature monitoring points. A low-rank approximation is physically appropriate because, in complex PCB or heatsink geometries, many temperature nodes exhibit similar spatial behavior, and multiple heat sources influence monitor points in correlated patterns. Therefore, only a few spatial basis functions are typically sufficient to represent all rows of $R$, and the same holds for $K$, since spatial variations in time constants tend to evolve smoothly across the domain. In essence, the temperature fields vary smoothly with position, the thermal influence of each source decays gradually with distance, and many rows of $R$ and $K$ are strongly correlated. Thus, most of the system’s energy can be captured by a small number of dominant modes. To exploit this structure, the rectangular matrices are approximated using low-rank factorizations, 
$R = AB^{T}$ and $K = CD^{T}$, where $A \in \mathbb{R}^{M \times r}$ and $B \in \mathbb{R}^{N \times r}$, where $r$ denotes the chosen rank. For the inverter module with six heat sources ($N$) and eight monitoring points ($M$), the full matrices contain 48 parameters each. A rank-3 representation reduces this to 42 parameters $(A: 24, B: 18)$, and a rank-2 representation reduces it further to only 28 parameters. This reduction dramatically accelerates optimization and results in smoother estimates while accommodating the rectangular structure of the matrices. From the case studies it is observed that even a rank-1 approximation works well, rank-2 is almost always sufficient, and rank-3 is nearly indistinguishable from the full model. In the reduced formulation, each element of the coupling matrices is expressed as, $R_{ij} = \sum_{k=1}^{r} A_{ik} B_{jk}, K_{ij} = \sum_{k=1}^{r} C_{ik} D_{jk},$ and only the elements of $A$, $B$, $C$, and $D$ are optimized. The rank estimation can also be done algorithmically by computing the singular value decomposition (SVD) of $R, K$ matrices. The singular values $\sigma_i$, indicate the relative contribution of each mode, and enables selection of the smallest number of modes that captures a desired fraction $\tau$ of the total information. For highly nonlinear convection dominated flows, where the reciprocity of parameters does not hold, rank‑reduction is the most appropriate and mathematically consistent approach.
```math
	\begin{split}
		r^\star &= \min \left\{ k \;\middle|\;
		\sum_{i=1}^{k} \frac{\sigma_i}{\sum_{j} \sigma_j} \ge \tau \right\}, \\
		R &= \sum_{i=1}^{r^\star} \sigma_i \, \mathbf{u}_i \mathbf{v}_i^{\top}, 
		\qquad
		\sigma_1 \ge \sigma_2 \ge \cdots \ge \sigma_{r^\star} .
	\end{split}
```
A pseudocode for this can be found in the following work [^SAE2]. The code for Naive implementation of ensemble parameter estimation for LPLSP model is located in the **Location:** code/ensemble_parameter_estimation

# References
[^SAE1]: Padmanabhan, N., "A Scalable Approach for Transient Thermal Modeling of Automotive Power Electronics," SAE Technical Paper Series, January 1, 2025, https://doi.org/10.4271/2025-01-5073.
[^SAE2]: Padmanabhan, N., "Rapid Modeling of Transient Thermal Systems through Ensemble Parameter Estimation Applied to the Lumped Parameter Linear Superposition Method," SAE Technical Paper Series, January 1, 2026, https://doi.org/10.4271/2026-01-5034.
[^POD]: Padmanabhan N., "Reduced order model of a convection-diffusion equation using Proper Orthogonal Decomposition," arXiv preprint arXiv:2303.07176. March 13, 2023. https://doi.org/10.48550/arXiv.2303.07176
