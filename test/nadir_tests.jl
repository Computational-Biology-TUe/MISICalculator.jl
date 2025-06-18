@testset "Find nadir" begin

    no_rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 1.0, 0.1]
    plateau = [0.0, 1.0, 2.0, 5.0, 3.0, 3.0, 3.0, 0.1]
    small_rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 3.3, 1.5, 0.1]
    rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 2.0, 2.6, 0.1]
    rebound_2 = [0.0, 1.0, 2.0, 5.0, 3.0, 3.3, 1.1, 1.5, 2.5, 2.0, 0.1] 

    @testset "No rebound" begin
        @test nadir_index(no_rebound) == 7
        @test global_minimum_index(no_rebound) == 7
    end

    @testset "Plateau" begin
        @test nadir_index(plateau) == 8
        @test global_minimum_index(plateau) == 8
    end

    @testset "Small rebound" begin
        @test nadir_index(small_rebound) == 5
        @test global_minimum_index(small_rebound) == 8
    end

    @testset "Rebound" begin
        @test nadir_index(rebound) == 6
        @test global_minimum_index(rebound) == 8
    end

    @testset "Rebound with multiple minima" begin
        @test nadir_index(rebound_2) == 5
        @test global_minimum_index(rebound_2) == 11
    end
end

