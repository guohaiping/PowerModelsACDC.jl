
"""
Creates Ohms constraints for DC branches

```
p[f_idx] + p[t_idx] == p * g[l] * (wdc[f_bus] - wdcr[f_bus,t_bus])
```
"""
function constraint_ohms_dc_branch(pm::GenericPowerModel{T}, n::Int, cnd::Int, f_bus, t_bus, f_idx, t_idx, r, p) where {T <: PowerModels.AbstractBFQPForm}
    l = f_idx[1];
    p_dc_fr = PowerModels.var(pm, n, cnd, :p_dcgrid, f_idx)
    p_dc_to = PowerModels.var(pm, n, cnd, :p_dcgrid, t_idx)
    ccm_dcgrid = PowerModels.var(pm, n, cnd, :ccm_dcgrid, l)
    wdc_fr = PowerModels.var(pm, n, cnd, :wdc, f_bus)
    wdc_to = PowerModels.var(pm, n, cnd, :wdc, t_bus)

    @constraint(pm.model, p_dc_fr + p_dc_to ==  r * p * ccm_dcgrid)
    @constraint(pm.model, p_dc_fr^2 <= p^2 * wdc_fr * ccm_dcgrid)
    @constraint(pm.model, wdc_to == wdc_fr - 2 * r * (p_dc_fr/p) + (r)^2 * ccm_dcgrid)
end

function constraint_ohms_dc_branch(pm::GenericPowerModel{T}, n::Int, cnd::Int, f_bus, t_bus, f_idx, t_idx, r, p) where {T <: PowerModels.AbstractBFConicForm}
    l = f_idx[1];
    p_dc_fr = PowerModels.var(pm, n, cnd, :p_dcgrid, f_idx)
    p_dc_to = PowerModels.var(pm, n, cnd, :p_dcgrid, t_idx)
    ccm_dcgrid = PowerModels.var(pm, n, cnd, :ccm_dcgrid, l)
    wdc_fr = PowerModels.var(pm, n, cnd, :wdc, f_bus)
    wdc_to = PowerModels.var(pm, n, cnd, :wdc, t_bus)

    @constraint(pm.model, p_dc_fr + p_dc_to ==  r * p * ccm_dcgrid)
    @constraint(pm.model, norm([2*p_dc_fr/p; wdc_fr - ccm_dcgrid])<= wdc_fr + ccm_dcgrid)
    @constraint(pm.model, wdc_to == wdc_fr - 2 * r * (p_dc_fr/p) + (r)^2 * ccm_dcgrid)
end
"""
Model to approximate cross products of node voltages
```
wdcr[(i,j)] <= wdc[i]*wdc[j]
```
"""
function constraint_voltage_dc(pm::GenericPowerModel{T}, n::Int = pm.cnw, cnd::Int = pm.ccnd) where {T <: PowerModels.AbstractBFForm}
# do nothing
end

function variable_dcbranch_current(pm::GenericPowerModel{T}; kwargs...) where {T <: PowerModels.AbstractBFForm}
    variable_dcbranch_current_sqr(pm; kwargs...)
end
function constraint_dc_branch_current(pm::GenericPowerModel{T}, n::Int, cnd::Int, f_bus, f_idx, ccm_max, p) where {T <: PowerModels.AbstractBFForm}
# do nothing
end
