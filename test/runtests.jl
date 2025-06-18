using MISICalculator, Test


@testset "Find nadir" begin
    include("nadir_tests.jl")
end 

@testset "Glucose slope tests" begin
    include("glucose_slope_tests.jl")
end
