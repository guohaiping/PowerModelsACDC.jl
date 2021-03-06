s = Dict("output" => Dict("branch_flows" => true), "conv_losses_mp" => true)
@testset "test ac polar pf" begin
    # @testset "3-bus case" begin
    #     result = run_acdcpf("../test/data/case3.m", ACPPowerModel, ipopt_solver, setting = Dict("output" => Dict("branch_flows" => true)))
    #
    #     @test result["status"] == :LocalOptimal
    #     @test isapprox(result["objective"], 0; atol = 1e-2)
    #
    #     @test isapprox(result["solution"]["gen"]["2"]["pg"], 1.600063; atol = 1e-3)
    #     @test isapprox(result["solution"]["gen"]["3"]["pg"], 0.0; atol = 1e-3)
    #
    #     @test isapprox(result["solution"]["bus"]["1"]["vm"], 1.10000; atol = 1e-3)
    #     @test isapprox(result["solution"]["bus"]["1"]["va"], 0.00000; atol = 1e-3)
    #     @test isapprox(result["solution"]["bus"]["2"]["vm"], 0.92617; atol = 1e-3)
    #     @test isapprox(result["solution"]["bus"]["3"]["vm"], 0.90000; atol = 1e-3)
    #
    #     @test isapprox(result["solution"]["dcline"]["1"]["pf"],  0.10; atol = 1e-5)
    #     @test isapprox(result["solution"]["dcline"]["1"]["pt"], -0.10; atol = 1e-5)
    #     @test isapprox(result["solution"]["dcline"]["1"]["qf"], -0.403045; atol = 1e-5)
    #     @test isapprox(result["solution"]["dcline"]["1"]["qt"],  0.0647562; atol = 1e-5)
    # end
    @testset "5-bus ac dc case" begin
        result = run_acdcpf("../test/data/case5_acdc.m", ACPPowerModel, ipopt_solver; setting = s)

        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 0; atol = 1e-2)

        @test isapprox(result["solution"]["gen"]["1"]["pg"], 1.3494; atol = 1e-3)
        @test isapprox(result["solution"]["gen"]["2"]["pg"], 0.40; atol = 1e-3)

        @test isapprox(result["solution"]["bus"]["1"]["vm"], 1.06; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["1"]["va"], 0.00000; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["2"]["vm"], 1.00; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["3"]["vm"], 0.995; atol = 1e-3)

        @test isapprox(result["solution"]["convdc"]["2"]["pgrid"], -0.1954; atol = 1e-3)
        @test isapprox(result["solution"]["convdc"]["3"]["pdc"], 0.36421; atol = 1e-3)
        @test isapprox(result["solution"]["busdc"]["1"]["vm"], 1.008; atol = 1e-3)

    end
    @testset "5-bus ac dc case with 2 seperate ac grids" begin
        result = run_acdcpf("../test/data/case5_2grids.m", ACPPowerModel, ipopt_solver; setting = s)

        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 0; atol = 1e-2)

        @test isapprox(result["solution"]["gen"]["1"]["pg"], 1.9326; atol = 1e-3)
        @test isapprox(result["solution"]["gen"]["4"]["pg"], 0.40; atol = 1e-3)

        @test isapprox(result["solution"]["bus"]["1"]["vm"], 1.06; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["1"]["va"], 0.00000; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["3"]["vm"], 0.987; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["7"]["va"], -0.0065; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["10"]["vm"], 0.972; atol = 1e-3)

        @test isapprox(result["solution"]["convdc"]["1"]["pgrid"], 0.6; atol = 1e-3)
        @test isapprox(result["solution"]["convdc"]["2"]["pdc"], 0.56872; atol = 1e-3)
        @test isapprox(result["solution"]["busdc"]["1"]["vm"], 1.015; atol = 1e-3)
    end
    @testset "24-bus rts ac dc case with three zones" begin
        result = run_acdcpf("../test/data/case24_3zones_acdc.m", ACPPowerModel, ipopt_solver; setting = s)

        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 0; atol = 1e-2)

        @test isapprox(result["solution"]["gen"]["65"]["pg"], 1.419; atol = 1e-3)
        @test isapprox(result["solution"]["gen"]["65"]["qg"], -1.2965; atol = 1e-3)


        @test isapprox(result["solution"]["bus"]["101"]["vm"], 1.035; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["101"]["va"], -0.1389; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["205"]["vm"], 1.032; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["301"]["vm"], 1.026; atol = 1e-3)

        @test isapprox(result["solution"]["convdc"]["2"]["pgrid"], -0.7536; atol = 1e-3)
        @test isapprox(result["solution"]["convdc"]["3"]["pdc"], -1.37298; atol = 1e-3)
        @test isapprox(result["solution"]["busdc"]["5"]["vm"], 1.017; atol = 1e-3)
    end
end


@testset "test dc pf" begin
    # @testset "3-bus case" begin
    #     result = run_acdcpf("../test/data/case3.m", DCPPowerModel, ipopt_solver)
    #
    #     @test result["status"] == :LocalOptimal
    #     @test isapprox(result["objective"], 0; atol = 1e-2)
    #
    #     @test isapprox(result["solution"]["gen"]["1"]["pg"], 1.54994; atol = 1e-3)
    #
    #     @test isapprox(result["solution"]["bus"]["1"]["va"],  0.00000; atol = 1e-5)
    #     @test isapprox(result["solution"]["bus"]["2"]["va"],  0.09147654582; atol = 1e-5)
    #     @test isapprox(result["solution"]["bus"]["3"]["va"], -0.28291891895; atol = 1e-5)
    # end
    @testset "5-bus ac dc case" begin
        result = run_acdcpf("../test/data/case5_acdc.m", DCPPowerModel, ipopt_solver; setting = s)

        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 0; atol = 1e-2)

        @test isapprox(result["solution"]["gen"]["1"]["pg"], 1.2169; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["5"]["va"], -0.09289; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["3"]["va"], -0.0826; atol = 1e-3)
        @test isapprox(result["solution"]["convdc"]["2"]["pgrid"], -0.2831; atol = 1e-3)
        @test isapprox(result["solution"]["convdc"]["3"]["pdc"], -0.3385; atol = 1e-3)
    end
    @testset "24-bus rts ac dc case with three zones" begin
        result = run_acdcpf("../test/data/case24_3zones_acdc.m", DCPPowerModel, ipopt_solver; setting = s)

        @test result["status"] == :LocalOptimal
        @test isapprox(result["objective"], 0; atol = 1e-2)
        @test isapprox(result["solution"]["gen"]["65"]["pg"], 1.419; atol = 1e-3)

        @test isapprox(result["solution"]["bus"]["119"]["va"], 0.17208; atol = 1e-3)
        @test isapprox(result["solution"]["bus"]["224"]["va"], 0.07803; atol = 1e-3)

        @test isapprox(result["solution"]["convdc"]["2"]["pgrid"], -0.753; atol = 1e-3)
        @test isapprox(result["solution"]["convdc"]["3"]["pdc"], 1.43579; atol = 1e-3)
    end
end

#TODO check for minimum loss solutions
# @testset "test soc pf" begin
#     @testset "5-bus ac dc case" begin
#         result = run_acdcpf("../test/data/case5_acdc.m", SOCWRPowerModel, ipopt_solver)
#
#         @test result["status"] == :LocalOptimal
#         @test isapprox(result["objective"], 0; atol = 1e-2)
#
#         @test isapprox(result["solution"]["gen"]["1"]["pg"], 12.258; atol = 1e-3)
#         @test isapprox(result["solution"]["gen"]["1"]["qg"], 13.264; atol = 1e-3)
#
#         @test isapprox(result["solution"]["bus"]["1"]["vm"], 1.06; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["1"]["va"], 0.00000; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["3"]["vm"], 0.987; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["7"]["va"], -0.0065; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["10"]["vm"], 0.972; atol = 1e-3)
#
#         @test isapprox(result["solution"]["convdc"]["1"]["pgrid"], 0.6; atol = 1e-3)
#         @test isapprox(result["solution"]["convdc"]["2"]["pdc"], 0.56872; atol = 1e-3)
#         @test isapprox(result["solution"]["busdc"]["1"]["vm"], 1.015; atol = 1e-3)
#     end
#     @testset "24-bus rts ac dc case with three zones" begin
#         result = run_acdcpf("../test/data/case24_3zones_acdc.m", SOCWRPowerModel, ipopt_solver)
#
#         @test result["status"] == :LocalOptimal
#         @test isapprox(result["objective"], 0; atol = 1e-2)
#
#         @test isapprox(result["solution"]["gen"]["65"]["pg"], 1.419; atol = 1e-3)
#         @test isapprox(result["solution"]["gen"]["65"]["qg"], 11.1026; atol = 1e-3)
#
#
#         @test isapprox(result["solution"]["bus"]["101"]["vm"], 1.035; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["205"]["vm"], 0.88996; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["301"]["vm"], 1.0202; atol = 1e-3)
#
#         @test isapprox(result["solution"]["convdc"]["2"]["pgrid"], -0.753; atol = 1e-3)
#         @test isapprox(result["solution"]["convdc"]["3"]["pdc"], -1.3671; atol = 1e-3)
#         @test isapprox(result["solution"]["busdc"]["5"]["vm"], 1.0004; atol = 1e-3)
#     end
# end
#
#
#
# @testset "test soc distflow pf_bf" begin
#     @testset "5-bus ac dc case" begin
#         result = run_acdcpf("../test/data/case5_acdc.m", SOCDFPowerModel, ipopt_solver)
#
#         @test result["status"] == :LocalOptimal
#         @test isapprox(result["objective"], 0; atol = 1e-2)
#
#         @test result["solution"]["gen"]["1"]["pg"] >= 1.480
#
#         @test isapprox(result["solution"]["gen"]["2"]["pg"], 1.600063; atol = 1e-3)
#         @test isapprox(result["solution"]["gen"]["3"]["pg"], 0.0; atol = 1e-3)
#
#         @test isapprox(result["solution"]["bus"]["1"]["vm"], 1.09999; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["2"]["vm"], 0.92616; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["3"]["vm"], 0.89999; atol = 1e-3)
#
#         @test isapprox(result["solution"]["dcline"]["1"]["pf"],  0.10; atol = 1e-4)
#         @test isapprox(result["solution"]["dcline"]["1"]["pt"], -0.10; atol = 1e-4)
#     end
#     @testset "24-bus rts ac dc case with three zones" begin
#         result = run_acdcpf("../test/data/case24_3zones_acdc.m", SOCDFPowerModel, ipopt_solver)
#
#         @test result["status"] == :LocalOptimal
#         @test isapprox(result["objective"], 0; atol = 1e-2)
#     end
# end
#
#
# @testset "test sdp pf" begin
#     #=
#     #seems to be having an issue on linux (04/02/18)
#     @testset "5-bus ac dc case" begin
#         result = run_pf("../test/data/case5_acdc.m", SDPWRMPowerModel, scs_solver)
#
#         @test result["status"] == :Optimal
#         @test isapprox(result["objective"], 0; atol = 1e-2)
#
#         @test result["solution"]["gen"]["1"]["pg"] >= 1.480
#
#         @test isapprox(result["solution"]["gen"]["2"]["pg"], 1.600063; atol = 1e-3)
#         @test isapprox(result["solution"]["gen"]["3"]["pg"], 0.0; atol = 1e-3)
#
#         @test isapprox(result["solution"]["bus"]["1"]["vm"], 1.09999; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["2"]["vm"], 0.92616; atol = 1e-3)
#         @test isapprox(result["solution"]["bus"]["3"]["vm"], 0.89999; atol = 1e-3)
#
#         @test isapprox(result["solution"]["dcline"]["1"]["pf"],  0.10; atol = 1e-4)
#         @test isapprox(result["solution"]["dcline"]["1"]["pt"], -0.10; atol = 1e-4)
#     end
#     =#
#     @testset "24-bus rts ac dc case with three zones" begin
#         result = run_acdcpf("../test/data/case24_3zones_acdc.m", SDPWRMPowerModel, scs_solver)
#
#         @test result["status"] == :Optimal
#         @test isapprox(result["objective"], 0; atol = 1e-2)
#     end
# end
