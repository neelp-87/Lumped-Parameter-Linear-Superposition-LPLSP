\# Lumped Parameter Linear Superposition (LPLSP) model



The LPLSP model is empirically derived but grounded in the theory of heat transfer. The formulation is developed in steps: it is first presented for a single insulated body, then extended to conduction between two bodies, then extended to convection between one body and fluid, and finally generalized to include mixed modes of heat transfer, including convection under both constant and variable flow velocities.



\## Formulation



The transient form of heat equation considering constant properties at atmospheric pressures can be expressed as,

$$

&#x20;   \\frac{\\partial T}{\\partial t} = \\alpha \\nabla^2 T + \\frac{P}{\\rho c\_p},

$$

where, $P$ is the heat source, $\\rho, c\_p ,k$ represent the density, specific heat capacity and thermal conductivity of the material, respectively, $T$ the temperature, $x\_i,t$ the spatial and temporal terms, $\\alpha= k/\\rho c\_p$ is the thermal diffusivity and $\\nabla^2$ the Laplace operator. The transient temperature response can be expressed by integrating Eq. \\eqref{eqmain1} with respect to time, 

$$

&#x20;   T(t)=D(t) + \\frac{P}{\\rho c\_p} t + c\_{int}. 

$$

where, $D(t)=\\alpha \\int \\nabla^2 T dt$ represents the time integrated diffusion term and $c\_{int}$ the integration constant which can be determined from the initial condition. This equation forms the basis of the proposed model. The model derivation involved fitting a specific form of this equation to the temperature data obtained from CFD simulations. The resulting model constants were optimized and then analyzed to relate them back to the physical parameters of the system.

