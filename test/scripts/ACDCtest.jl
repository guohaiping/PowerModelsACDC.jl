using PowerModelsACDC
using PowerModels
using Ipopt
#using CPLEX
using SCS
using Mosek

file_pf_droop = "./test/data/case5_acdc_droop.m"

file_case5acdc = "./test/data/case5_acdc.m"
file_case5dc ="./test/data/case5_dc.m"
file_case5dcgrid ="./test/data/case5_dcgrid.m"
file_case5dcgridb0 ="./test/data/case5_dcgrid_b0.m"
file_case24 = "./test/data/case24_3zones_acdc.m"
file_case39 = "./test/data/case39_acdc.m"
file_case3120 = "./test/data/case3120sp_acdc.m"
file_case5dcgrid = "./test/data/case5_dcgrid.m"
file_case5_b2bdc = "./test/data/case5_b2bdc.m"
file_lcc = "./test/data/lcc_test.m"
file_588sdet_acdc = "./test/data/pglib_opf_case588_sdet_acdc.m"
file = file_case5acdc

data = PowerModels.parse_file(file)

#TODO CHECK DF, WRM, WRM!!!!!!

PowerModelsACDC.process_additional_data!(data)
#display(data)
#scs = SCSSolver(max_iters=100000, verbose=0);
scs = SCSSolver(max_iters=100000);
ipopt = IpoptSolver(tol=1e-6)
mosek = MosekSolver()
#mosek = MosekSolver()
s = Dict("output" => Dict("branch_flows" => true), "conv_losses_mp" => true)

resultAC = run_acdcopf(file, ACPPowerModel, ipopt; setting = s)

resultQC = run_acdcopf(file, QCWRPowerModel, ipopt; setting = s)
# # #
resultQCTri = run_acdcopf(file, QCWRTriPowerModel, ipopt; setting = s)
resultACQCTri = PowerModels.run_opf(file, QCWRPowerModel, ipopt; setting = s)
# #
resultSOCBIM = run_acdcopf(file, SOCWRPowerModel, ipopt; setting = s)
resultACSOCBIM = PowerModels.run_opf(file, SOCWRPowerModel, ipopt; setting = s)
# #
resultSOCBFM = run_acdcopf_bf(file, SOCBFPowerModel, ipopt; setting = s)
resultSOCBFMConic = PowerModels.run_opf_bf(file, SOCBFConicPowerModel, mosek; setting = s)
# #
resultSDP = run_acdcopf(file, SDPWRMPowerModel, mosek; setting = s)
# #
resultDC = run_acdcopf(file, DCPPowerModel, ipopt; setting = s)
#
# # # other tests
# resultACPF24 = run_acdcpf(file_case24, ACPPowerModel, ipopt; setting = s)
resultACPF5 = run_acdcpf(file_case5acdc, ACPPowerModel, ipopt; setting = s)
# resultACPF5_droop = run_acdcpf(file_pf_droop, ACPPowerModel, ipopt; setting = s)
# resultAC5b2b = run_acdcopf(file_case5_b2bdc, ACPPowerModel, ipopt; setting = s)
# resultAC39 = run_acdcopf(file_case39, ACPPowerModel, ipopt; setting = s)
# resultAC3120 = run_acdcopf(file_case3120, ACPPowerModel, ipopt; setting = s)
# resultBFM3120 = run_acdcopf(file_case3120, SOCDFPowerModel, ipopt; setting = s)
# resultDCgrid5 = run_acdcopf(file_case5dcgrid, ACPPowerModel, ipopt; setting = s)
#
# resultAConlyAC = run_opf(file, ACPPowerModel, ipopt; setting = s)
#
# resultSOCBIMonlyAC = run_opf(file, SOCWRPowerModel, ipopt; setting = s)
# # matpower style dc line
# resultDCMP = run_acdcopf(file, DCPPowerModel, ipopt; setting = s)

# implement PF problem for validation:
# (2) Converter setpoints as constraint (constraint_active_gen_setpoint, constraint_reactive_gen_setpoint)
# (3) Voltage magnitude setpoints for the DC buses
