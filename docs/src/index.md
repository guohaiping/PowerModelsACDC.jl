# PowerModelACDC.jl Documentation

```@meta
CurrentModule = PowerModelsACDC
```

## Overview

PowerModelsACDC.jl is a Julia/JuMP package extending PowerModels.jl, which focuses on Steady-State Power Network Optimization. PowerModels.jl provides utilities for parsing and modifying network data and is designed to enable computational evaluation of emerging power network formulations and algorithms in a common platform.

PowerModelsACDC.jl adds new problem types:
- Power flow with both ac and dc lines, from point-to-point connections to meshed grids, with converters connecting ac and dc grid lines
- The equivalent optimal power flow problem type

PowerModelsACDC.jl extends the formulation hierarchy developed for AC grids, with equivalent DC grid and converter station formulations:
- ACPPowerModel
- DCPPowerModel
- SOCWRPowerModel
- SDPWRMPowerModel
- QCWRPowerModel
- QCWRTriPowerModel

Developed by:
- Hakan Ergun, Jay Dave KU Leuven / EnergyVille
- Frederik Geth, CSIRO


## Installation of PowerModelACDC

The latest stable release of PowerModelACDC can be installed using the Julia package manager with

```julia
Pkg.clone("https://github.com/hakanergun/PowerModelsACDC.jl.git")
```
The package is compatible with PowerModels v0.9.2, InfrastrucureModels v0.0.13 and julia v0.7.

!!! note
    This is a research-grade optimization package. Eventually, we hope to make this a
    stable julia package.


## Special Thanks To
Jef Beerten (KU Leuven/EnergyVille) for his insights in AC/DC power flow modelling.
Carleton Coffrin (Los Alamos National Laboratory) for his countless design tips.  
