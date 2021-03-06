function add_ref_dcgrid!(pm::GenericPowerModel, n::Int)
    if haskey(pm.ref[:nw][n], :convdc)
        #Filter converters & DC branches with status 0 as well as wrong bus numbers
        pm.ref[:nw][n][:convdc] = Dict([x for x in pm.ref[:nw][n][:convdc] if (x.second["status"] == 1 && x.second["busdc_i"] in keys(pm.ref[:nw][n][:busdc]) && x.second["busac_i"] in keys(pm.ref[:nw][n][:bus]))])
        pm.ref[:nw][n][:branchdc] = Dict([x for x in pm.ref[:nw][n][:branchdc] if (x.second["status"] == 1 && x.second["fbusdc"] in keys(pm.ref[:nw][n][:busdc]) && x.second["tbusdc"] in keys(pm.ref[:nw][n][:busdc]))])

        # DC grid arcs for DC grid branches
        pm.ref[:nw][n][:arcs_dcgrid_from] = [(i,branch["fbusdc"],branch["tbusdc"]) for (i,branch) in pm.ref[:nw][n][:branchdc]]
        pm.ref[:nw][n][:arcs_dcgrid_to]   = [(i,branch["tbusdc"],branch["fbusdc"]) for (i,branch) in pm.ref[:nw][n][:branchdc]]
        pm.ref[:nw][n][:arcs_dcgrid] = [pm.ref[:nw][n][:arcs_dcgrid_from]; pm.ref[:nw][n][:arcs_dcgrid_to]]
        pm.ref[:nw][n][:arcs_conv_acdc] = [(i,conv["busac_i"],conv["busdc_i"]) for (i,conv) in pm.ref[:nw][n][:convdc]]
        #bus arcs of the DC grid
        bus_arcs_dcgrid = Dict([(bus["busdc_i"], []) for (i,bus) in pm.ref[:nw][n][:busdc]])
        for (l,i,j) in pm.ref[:nw][n][:arcs_dcgrid]
            push!(bus_arcs_dcgrid[i], (l,i,j))
        end
        pm.ref[:nw][n][:bus_arcs_dcgrid] = bus_arcs_dcgrid

        # bus_convs for AC side power injection of DC converters
        bus_convs_ac = Dict([(i, []) for (i,bus) in pm.ref[:nw][n][:bus]])
        for (i,conv) in pm.ref[:nw][n][:convdc]
            push!(bus_convs_ac[conv["busac_i"]], i)
        end
        pm.ref[:nw][n][:bus_convs_ac] = bus_convs_ac

        # bus_convs for AC side power injection of DC converters
        bus_convs_dc = Dict([(bus["busdc_i"], []) for (i,bus) in pm.ref[:nw][n][:busdc]])
        for (i,conv) in pm.ref[:nw][n][:convdc]
            push!(bus_convs_dc[conv["busdc_i"]], i)
        end
        pm.ref[:nw][n][:bus_convs_dc] = bus_convs_dc
        # Add DC reference buses
        ref_buses_dc = Dict{String, Any}()
        for (k,v) in pm.ref[:nw][n][:convdc]
            if v["type_dc"] == 2
                ref_buses_dc["$k"] = v
            end
        end

        if length(ref_buses_dc) == 0
            for (k,v) in pm.ref[:nw][n][:convdc]
                if v["type_ac"] == 2
                    ref_buses_dc["$k"] = v
                end
            end
            warn(PowerModels.LOGGER, "no reference DC bus found, setting reference bus based on AC bus type")
        end

        for (k,conv) in pm.ref[:nw][n][:convdc]
            conv_id = conv["index"]
            if conv["type_ac"] == 2 && conv["type_dc"] == 1
                warn(PowerModels.LOGGER, "For converter $conv_id is chosen P is fixed on AC and DC side. This can lead to infeasibility in the PF problem.")
            elseif conv["type_ac"] == 1 && conv["type_dc"] == 1
                warn(PowerModels.LOGGER, "For converter $conv_id is chosen P is fixed on AC and DC side. This can lead to infeasibility in the PF problem.")
            end
            convbus_ac = conv["busac_i"]
            if conv["Vmmax"] < pm.ref[:nw][n][:bus][convbus_ac]["vmin"]
                warn(PowerModels.LOGGER, "The maximum AC side voltage of converter $conv_id is smaller than the minimum AC bus voltage")
            end
            if conv["Vmmin"] > pm.ref[:nw][n][:bus][convbus_ac]["vmax"]
                warn(PowerModels.LOGGER, "The miximum AC side voltage of converter $conv_id is larger than the maximum AC bus voltage")
            end
        end

        if length(ref_buses_dc) > 1
            ref_buses_warn = ""
            for (rb) in keys(ref_buses_dc)
                ref_buses_warn = ref_buses_warn*rb*", "
            end
            warn(PowerModels.LOGGER, "multiple reference buses found, i.e. "*ref_buses_warn*"this can cause infeasibility if they are in the same connected component")
        end
        ACgrids = find_all_ac_grids(pm.ref[:nw][n][:branch], pm.ref[:nw][n][:bus])


        for (i, grid) in ACgrids
            a = 0
            for (j, bus) in pm.ref[:nw][n][:ref_buses]
                if (bus["bus_i"] in grid["Buses"])
                    a = 1
                end
            end
            if a == 0
                warn(PowerModels.LOGGER, "Grid $i does not have any voltage reference bus, this might cause infeasibility")
            end
        end
        pm.ref[:nw][n][:ref_buses_dc] = ref_buses_dc
        pm.ref[:nw][n][:buspairsdc] = buspair_parameters_dc(pm.ref[:nw][n][:arcs_dcgrid_from], pm.ref[:nw][n][:branchdc], pm.ref[:nw][n][:busdc])
    else
        pm.ref[:nw][n][:convdc] = Dict{String, Any}()
        pm.ref[:nw][n][:busdc] = Dict{String, Any}()
        pm.ref[:nw][n][:branchdc] = Dict{String, Any}()
        # DC grid arcs for DC grid branches
        pm.ref[:nw][n][:arcs_dcgrid] = Dict{String, Any}()
        pm.ref[:nw][n][:arcs_conv_acdc] = Dict{String, Any}()
        pm.ref[:nw][n][:bus_arcs_dcgrid] = Dict{String, Any}()
        bus_convs_ac = Dict([(i, []) for (i,bus) in pm.ref[:nw][n][:bus]])
        for (i,conv) in pm.ref[:nw][n][:convdc]
            push!(bus_convs_ac[conv["busac_i"]], i)
        end
        pm.ref[:nw][n][:bus_convs_ac] = bus_convs_ac
        pm.ref[:nw][n][:bus_convs_dc] = Dict{String, Any}()
        pm.ref[:nw][n][:ref_buses_dc] = Dict{String, Any}()
        pm.ref[:nw][n][:buspairsdc] = Dict{String, Any}()
    end
end
add_ref_dcgrid!(pm::GenericPowerModel) = add_ref_dcgrid!(pm::GenericPowerModel, pm.cnw)


"compute bus pair level structures"
function buspair_parameters_dc(arcs_dcgrid_from, branches, buses)
    buspair_indexes = collect(Set([(i,j) for (l,i,j) in arcs_dcgrid_from]))

    bp_branch = Dict([(bp, Inf) for bp in buspair_indexes])

    for (l,branch) in branches
        i = branch["fbusdc"]
        j = branch["tbusdc"]

        bp_branch[(i,j)] = min(bp_branch[(i,j)], l)
    end

    buspairs = Dict([((i,j), Dict(
    "branch"=>bp_branch[(i,j)],
    "vm_fr_min"=>buses[i]["Vdcmin"],
    "vm_fr_max"=>buses[i]["Vdcmax"],
    "vm_to_min"=>buses[j]["Vdcmin"],
    "vm_to_max"=>buses[j]["Vdcmax"]
    )) for (i,j) in buspair_indexes])

    return buspairs
end

function find_all_ac_grids(branches_ac, buses_ac)
    ACgrids = Dict{String, Any}()

    if isempty(branches_ac)
        for (i, bus) in buses_ac
            ACgrids["$i"] = Dict{String, Any}()
            ACgrids["$i"]["Buses"] = bus["index"]
        end
    else
        ACgrids["1"] = Dict{String, Any}()
        ACgrids["1"]["Buses"] = [branches_ac[1]["f_bus"] branches_ac[1]["t_bus"]]
        closed_buses = [branches_ac[1]["f_bus"] branches_ac[1]["t_bus"]]
        closed_branches = [1]
        connections = []
        buses = []
        for (i, bus) in buses_ac
            if VERSION < v"0.7.0-"
                buses = cat(1,buses,bus["index"])
            else
                buses = cat(buses, bus["index"], dims = 1)
            end
        end
        grid_id = 1
        iter_id = 1
        branch_iter = 1
        while length(closed_buses) != length(buses) && iter_id < 10
            while branch_iter <= length(branches_ac)
                for (i, branch) in branches_ac
                    for (index, grid) in ACgrids
                        if (branch["t_bus"] in grid["Buses"]) && (branch["f_bus"] in grid["Buses"])
                            if !(branch["index"] in closed_branches)
                                closed_branches = [closed_branches branch["index"]]
                            end
                        elseif (branch["f_bus"] in grid["Buses"])
                            if !(branch["t_bus"] in grid["Buses"])
                                ACgrids["$index"]["Buses"] = [grid["Buses"] branch["t_bus"]]
                                closed_buses = [closed_buses branch["t_bus"]]
                                closed_branches = [closed_branches branch["index"]]
                            end
                        elseif (branch["t_bus"] in grid["Buses"])
                            if !(branch["f_bus"] in grid["Buses"])
                                ACgrids["$index"]["Buses"] = [grid["Buses"] branch["f_bus"]]
                                closed_buses = [closed_buses branch["f_bus"]]
                                closed_branches = [closed_branches branch["index"]]
                            end
                        end
                    end
                end
                branch_iter = branch_iter + 1
            end
            if length(closed_branches) < length(branches_ac)
                grid_id = grid_id + 1
                branch_iter = 1
                ACgrids["$grid_id"] = Dict{String, Any}()
                for (i, branch) in branches_ac
                    if !(branch["index"] in closed_branches) && isempty(ACgrids["$grid_id"])
                        ACgrids["$grid_id"]["Buses"] = [branch["f_bus"] branch["t_bus"]]
                        closed_branches = [closed_branches branch["index"]]
                    end
                end
            end
            iter_id = iter_id + 1 # to avoid infinite loop -> if not all subgrids detected
        end
    end
    return ACgrids
end
