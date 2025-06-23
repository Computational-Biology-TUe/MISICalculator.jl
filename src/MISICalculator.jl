#=
This is a Julia package for calculating the Muscle Insulin Sensitivity Index (MISI) from glucose and insulin data from an oral glucose tolerance test (OGTT). The code is based on the work and the MATLAB GUI of O’Donovan et al. [1]
Copyright (C) 2025  Shauna D. O'Donovan

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.


[1]: O’Donovan, S. D. et al. Improved quantification of muscle insulin sensitivity using oral glucose tolerance test data: the MISI Calculator. Sci Rep 9, 9388 (2019)
=#

module MISICalculator
    include("misi.jl")

    export misi
    export nadir_index, global_minimum_index, glucose_slope, spline_fit, lsqfit
    export MISIResult

end # module MISICalculator
