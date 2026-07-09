# Lumped Parameter Linear Superposition (LPLSP) model
The LPLSP model is empirically derived but grounded in the theory of heat transfer. The formulation is developed in steps: it is first presented for a single insulated body, then extended to conduction between two bodies, then extended to convection between one body and fluid, and finally generalized to include mixed modes of heat transfer, including convection under both constant and variable flow velocities. The fomulation described here features excerpts from the works of Padmanabhan [^IEEE].[^SAE1]. The readers are referred to the cited papers for a more detailed background, formulation, motivation and case studies.

## Formulation
The transient form of heat equation considering constant properties at atmospheric pressures can be expressed as,
```math
    \frac{\partial T}{\partial t} = \alpha \nabla^2 T + \frac{P}{\rho c_p},
```
where, $P$ is the heat source, $\rho, c_p ,k$ represent the density, specific heat capacity and thermal conductivity of the material, respectively, $T$ the temperature, $x_i,t$ the spatial and temporal terms, $\alpha= k/\rho c_p$ is the thermal diffusivity and $\nabla^2$ the Laplace operator. The transient temperature response can be expressed by integrating this equation with respect to time,
```math
    T(t)=D(t) + \frac{P}{\rho c_p} t + c_{int}.
```
where, $D(t)=\alpha \int \nabla^2 T dt$ represents the time integrated diffusion term and $c_{int}$ the integration constant which can be determined from the initial condition. This equation forms the basis of the proposed model.

## Model for one insulated body
For a single insulated cuboidal body, the transient temperature response is observed to be linear. This behavior can be derived from the generalized equation under the assumption that the temperature diffusion across a body is instantaneous, or equivalently, the spatial gradient of temperature is negligible. Under this assumption, the diffusion term $D(t)$ can be considered constant or zero, resulting in a simplified expression for temperature evolution as,
```math
    T(t)=T^0 + T^L(t) = T^0 + \Bigl(\frac{P}{C} \Bigr) t,
```
where, $T^0$ is the initial temperature, $P$ the total power applied to the body, $C=\rho c_p V$ the thermal capacitance of the body, and $V$ the volume of the body. Simulation results for the insulated body confirm that the temperature increases linearly over time, with a slope given by $T^L = (P/C)$.  

## Model for two insulated bodies (Conduction Dominated)
Extending from a single insulated body to two cuboidal bodies insulated from the surroundings, it is observed that the spatial gradient can no longer be neglected due to heat conduction from source to sink body. Even in three-dimensional geometry, the temperature gradient is observed to be significant only along the direction of heat flow. The temperatures at the centers of each body $T_i (t)$ are observed to be,
```math
\begin{aligned}
    T _{1} (t)=T^0+T^L(t)+T^{D} _{1}(t),\\
    T _{2} (t)=T^0+T^L(t)+T^{D} _{2}(t).
\end{aligned}
```
The linear temperature term is defined as $T^L(t)=(P_T / C_T) t$, where the ratio $P_T/C_T = \sum_{i=1} ^2 P_i / \sum_{i=1} ^2 C_i$ represents the total power input applied to both bodies divided by their combined thermal capacitance. The linear temperature curve $T^L(t)$ lies between temperatures $T_1(t)$ and $T_2(t)$, and can be computed a priori using the material properties, geometrical details of the bodies and input power dissipation. The spatial location (plane in this case) denoted by $x_{P_{T}/C_{T}}$ where $T^L(t)$ is observed, depends on the applied power dissipation, and thermal capacitance of each body. For bodies with similar thermal capacitances and power dissipation, this location typically lies near the midpoint between the two bodies. However, for bodies with differing capacitances, the linear temperature plane shifts closer to the body with the larger thermal capacitance. The term $T^{D}_i (t)$, models the deviation in temperature between the body $T^{s}_i(t)$, measured from the simulation and $T^L(t)$. This can be expressed as,
```math
	T^{D}_i (t)= T^{s}_i (t) - T^L(t). 
```
This deviation exhibits the characteristic transient response of an RC circuit and can be expressed as,
```math
    T^{D} _{i}(t)=E_i (1-e^{-\theta_i t}).
```
The term $E_i$ is the magnitude of deviation between the stationary temperature of body $i$ and the linear temperature curve $T^L(t)$, and is defined as,
```math
	E_i = |T^{s} _{i}(t_{s})-T^L(t_{s}))|, 
```
where $T^{s} _i(t_s)$ is the simulated temperature of the body $i$ and $t_s$ is the time after which the temperature reaches a quasi-stationary state. The sign of $E_i$ is positive if $T^{s} _{i} > T^L$, and negative otherwise, indicating whether the body is hotter or cooler than the linear temperature curve. This term is modeled as,
```math
    E_i = P_{i} R _{ij},
```
where, $P\_{i}$ is the applied power at body $i$ and $R\_{ij}$ the thermal resistance between the location $x\_i$ (where the temperature $T^{s}\_i$ is measured) and the location $x\_{P\_{T}/C\_{T}}$. The term $\theta\_i$ represents the time constant which characterizes the rate of change of temperature. In systems with two bodies where each body may act as the source, sink or both, the deviation terms must consider the effects of each source on the other. Thus, the principle of superposition is applied and the deviation terms are expressed as,
```math
    \begin{aligned}
        T^{D} _{1}(t) = (P_{1} R_{11} + P_{2} R_{12}) [1-e^{-\theta_1 t}], \\
        T^{D} _{2}(t) = (P_{1} R_{21} + P_{2} R_{22}) [1-e^{-\theta_2 t}].
    \end{aligned}
```
The term $R_{11}$ represents the thermal resistance between the body $B_1(x_1)$ and $x_{P_{T}/C_{T}}$, when power $P_1 = 1$ is applied to it and power $P_2=0$ is applied to $B_2$. This term can be obtained by running a simulation where $P_1=1, P_2=0$ is applied to bodies $B_1, B_2$, and computed as follows,  
```math
    R_{11} = \frac{T_1 ^{s} (t_s) - T^L (t_s)}{P_1}.
```
$T_1 ^{s} (t_s)$ in this equation is the temperature of $B_1$ measured from the simulation. Similarly, 
```math
\begin{aligned}
    R_{12} = (T_1 ^{s} (t_s) - T^L (t_s))/P_2, \\
    R_{21} = (T_2 ^{s} (t_s) - T^L (t_s))/P_1, \\
    R_{22} = (T_2 ^{s} (t_s) - T^L (t_s))/P_2,
\end{aligned}
```
The time constant $\theta_1=1/(C_T R_1 ^{e})$ is associated with thermal response of body 1 and computed using an effective resistance $R_1 ^{e}$, which is a weighted average of $R_{11}, R_{12}$. For transient systems with power dissipation $P_1(t), P_2(t)$, a piecewise approximation is applied and the model equation is modified as,
```math
    T^L (t)= \sum_j ^{n_T} \left[ \frac{P_{T,j}}{C_{T}} - \frac{P_{T,j-1}}{C_{T}} \right] (t-t^{0} _{j-1}),
```
with $P_{T,j}=P_{1,j}+P_{2,j}$. This expression applies to any generalized system consisting of two or more bodies. The total power dissipation and thermal capacitance terms are modified as $P_{T,j}=\sum_i ^{N_B} P_{i,j}, C_T=\sum_i ^{N_B} C_i$, where $N_B$ represents the number of bodies in the system.
```math
\begin{split}
    T^{D} _{1}(t) = \sum_j ^{n_T} [(P_{1,j} R_{11} + P_{2,j} R_{12}) \\ - (P_{1,j-1} R_{11} + P_{2,j-1} R_{12})] \\ (1-e^{-\theta_1 (t-t^{0} _{j-1})}), \\
    T^{D} _{2}(t) = \sum_j ^{n_T} [(P_{1,j} R_{21} + P_{2,j} R_{22}) \\ - (P_{1,j-1} R_{21} + P_{2,j-1} R_{22})] \\ (1-e^{-\theta_2 (t-t^{0} _{j-1})}),
\end{split}
```
where, $j$ is the index of number of changes in the input power, $n_T$ is total number of changes (transients) in the input, and $t^{0}\_{j}$ is the time instant at which the change in input powers occurs. The initial values are, $P\_{1,0}=0$, $P\_{2,0}=0$, $t^{0}\_{0}=0$.

## Model for multiple bodies with mixed conduction and convection
For convection heat transfer, the problem inherently has two mediums: the solid and the surrounding fluid. The governing equation must be modified to include the effects of flow velocity through continuity, Navier Stokes and energy equations, and the boundary condition must include convection boundary. For non-zero flow velocity, the temperature exhibits an exponential transient response, reaching a steady state more rapidly compared to purely conductive cases. This behavior is analogous to an association curve. The temperature evolution of the solid body in a fluid can be expressed as,
```math
    T_1(t)=T^0 + T^L(t) + P_{1} R^{SF} _1 (1-e^{-\theta^{SF}_1 t}).
```
The term $R^{SF} _1=1/hA$ denotes the thermal resistance between the solid body and the fluid, $h$ the convection heat transfer coefficient, $A$ the cross-sectional area, $\theta^{SF} _1=1/R^{SF}C^{SF}_T$ the time constant and $C^{SF} _{T}=C^S+C^F$ is the total thermal capacitance of the solid ($C^S$) and the fluid ($C^F$). The critical parameter here is the convection heat transfer coefficient that is often difficult to compute directly, but can be estimated from the data.

For constant flow velocity or for flow velocities that vary by a small magnitude as in case of natural convection, a single value of $h$ can be used to estimate $R^{SF}$. However, when the flow velocity varies with time, $h(t)=f(U_f(t))$, it is observed from multiple simulations that for small range of velocities $U_f=U_0 \pm 10 m/s$ (with $U_0$ as a reference velocity), the relationship between thermal resistance, time constant and flow velocities can be expressed as, $R_{ij} = m^R_i U_f ^{\gamma} + c^R_i, \theta_i = m^{\theta}_i U_f ^{\gamma} + c^{\theta}_i$.
Alternatively expressed, a linear relationship is observed between the parameters when the velocity is raised by a power $\gamma$. The model constants are obtained by running a parametric study for each heat source, for the specific range of velocities. Finally, the temperature of each component is determined by applying superposition considering the temperature rise due to applied power dissipation, variable velocity and effects of additional heat sources. This is expressed as,
```math
	\begin{aligned}
	T_1 (t) = T^0 + T^L(t) + \sum_j ^{n_T} \big[ P_1(t) R_{11} (U) [1-e^{-\theta_1 (U) (t-t^{0} _{j-1})}] \\ + P_2(t) R_{12} (U) [1-e^{-\theta_2 (U) (t-t^{0} _{j-1})}] \big], \\
	T_2 (t) = T^0 + T^L(t) + \sum_j ^{n_T} \big[ P_1(t) R_{21} (U) [1-e^{-\theta_1 (U) (t-t^{0} _{j-1})}] \\ + P_2(t) R_{22} (U) [1-e^{-\theta_2 (U) (t-t^{0} _{j-1})}] \big],
\end{aligned}
```
where, $j$ is the index of number of changes in the input power, $n_T$ is total number of changes (transients) in the input, and $t^{0} _{j}$ is the time instant at which the change in input powers occurs.


[^IEEE]: N. Padmanabhan, "A Transient Thermal Model for Power Electronics Systems," SoutheastCon 2024, Atlanta, GA, USA, 2024, pp. 1294-1299, doi: 10.1109/SoutheastCon52093.2024.10500091.
[^SAE1]: Padmanabhan, N., "A Scalable Approach for Transient Thermal Modeling of Automotive Power Electronics," SAE Technical Paper Series, January 1, 2025, https://doi.org/10.4271/2025-01-5073.
