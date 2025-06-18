@testset "Glucose slope tests" begin

    no_rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 1.0, 0.1]
    plateau = [0.0, 1.0, 2.0, 5.0, 3.0, 3.0, 3.0, 0.1]
    small_rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 3.3, 1.5, 0.1]
    rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 2.0, 2.6, 0.1]
    rebound_2 = [0.0, 1.0, 2.0, 5.0, 3.0, 3.3, 1.1, 1.5, 2.5, 2.0, 0.1] 

    @test glucose_slope(no_rebound, 1:length(no_rebound)) ≈ 1.67 atol=1e-2
    @test glucose_slope(plateau, 1:length(plateau)) ≈ 0.98 atol=1e-2
    @test glucose_slope(small_rebound, 1:length(small_rebound)) ≈ 2.0 atol=1e-2
    @test glucose_slope(rebound, 1:length(rebound)) ≈ 1.50 atol=1e-2
    @test glucose_slope(rebound_2, 1:length(rebound_2)) ≈ 2.0 atol=1e-2
end
