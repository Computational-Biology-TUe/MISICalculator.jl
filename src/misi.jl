
using XLSX, DataInterpolations, DataFrames
include("checks.jl")
include("results.jl")

function lsqfit(x, y)
    A = [ones(length(x)) x]
    return A \ y
end

function nadir_index(glucose)
    glucose_peak = argmax(glucose)
    glucose_after_peak = glucose[glucose_peak:end]

    i = 1
    dg = diff(glucose_after_peak)
    while i <= length(dg) && dg[i] <= 0
        i += 1
    end

    return argmin(glucose_after_peak[1:i]) + glucose_peak - 1
end

function global_minimum_index(glucose)
    peak_idx = argmax(glucose)
    glucose_after_peak = glucose[peak_idx:end]
    return argmin(glucose_after_peak) + peak_idx - 1
end

"""
    glucose_slope(glucose, time)

Calculate the least squares slope of the glucose data from peak to nadir.
"""
function glucose_slope(glucose, time; min_func = nadir_index)

    # Find peak and nadir indices
    peak_idx = argmax(glucose)
    nadir_idx = min_func(glucose)

    # Extract relevant data points
    glucose_segment = glucose[peak_idx:nadir_idx]
    time_segment = time[peak_idx:nadir_idx]

    # Fit a linear model to the segment
    p = lsqfit(time_segment, glucose_segment)

    return abs(p[2])  # Return the slope
end

function spline_fit(glucose, insulin, time; sample_each = 0.1)
    timepoints_spline = [[time[1]-30, time[1]-15, time[1]-7]; time]
    glucose_spline = [fill(glucose[1], 3); glucose]
    insulin_spline = [fill(insulin[1], 3); insulin]

    glucose_interpolated = CubicSpline(glucose_spline, timepoints_spline)(time[1]:sample_each:time[end])
    insulin_interpolated = CubicSpline(insulin_spline, timepoints_spline)(time[1]:sample_each:time[end])
    time_interpolated = time[1]:sample_each:time[end]
    return glucose_interpolated, insulin_interpolated, time_interpolated
end
    

function process_excel_file(file_path::String)
    glucose = DataFrame(XLSX.readtable(file_path, "glucose"))
    id_values = Vector{String}(glucose[1:end, 1])
    glucose_values = Matrix{Union{Float64, Missing}}(glucose[1:end, 2:end])
    time = DataFrame(XLSX.readtable(file_path, "time"))
    time_values = Vector{Union{Float64, Missing}}(time[1, 2:end])
    insulin = DataFrame(XLSX.readtable(file_path, "insulin"))
    insulin_values = Matrix{Union{Float64, Missing}}(insulin[1:end, 2:end])

    return id_values, glucose_values, time_values, insulin_values
end

function misi(glucose::AbstractVector{<:Real}, insulin::AbstractVector{<:Real}, time::AbstractVector{<:Real})

    if peak_at_final_timepoint(glucose)
        return MISIResult(0.0, "Peak at final timepoint", 0.0, 0.0)
    end

    dgdt = glucose_slope(glucose, time)
    dgdt_global = glucose_slope(glucose, time; min_func = global_minimum_index)
    Ī = sum(insulin) / length(insulin)
    misi = 1000*dgdt / Ī
    misi_global = 1000*dgdt_global / Ī

    glucose_interpolated, insulin_interpolated, time_interpolated = spline_fit(glucose, insulin, time)
    dgdt_spline = glucose_slope(glucose_interpolated, time_interpolated)
    Ī_spline = sum(insulin_interpolated) / length(insulin_interpolated)
    misi_spline = 1000 * dgdt_spline / Ī_spline

    if flat_glucose_curve(glucose)
        return MISIResult(misi, "Flat glucose curve. MISI may be unreliable.", misi_global, misi_spline)
    end

    if large_rebound(glucose)
        return MISIResult(misi, "Large rebound detected. MISI may be unreliable. Consider using MISI global.", misi_global, misi_spline)
    end

    if hypoglycemia(glucose)
        return MISIResult(misi, "Hypoglycemia detected. MISI may be unreliable.", misi_global, misi_spline)
    end

    return MISIResult(misi, "", misi_global, misi_spline)
end

function misi(glucose, insulin, time)
    # run checks
    if missing_values(glucose)
        return MISIResult("Missing values in glucose data")
    end
    if missing_values(insulin)
        return MISIResult("Missing values in insulin data")
    end
    if missing_values(time)
        return MISIResult("Missing values in time data")
    end

    try
        return misi(Float64.(glucose), Float64.(insulin), Float64.(time))
    catch 
        return MISIResult("Error in type conversion for glucose, insulin, or time data")
    end
end

function misi(excel_file::String, output_file_name::String)

    id_values, glucose_values, time_values, insulin_values = process_excel_file(excel_file)
    results = [
        misi(glucose_values[i, :], insulin_values[i, :], time_values)
        for i in axes(glucose_values, 1)
    ]
    result_df = DataFrame(
        id = id_values,
        misi = [result.misi for result in results],
        misi_global = [result.misi_global for result in results],
        misi_spline = [result.misi_spline for result in results],
        message = [result.message for result in results]
    )
    XLSX.writetable(output_file_name, "results" => result_df)
    println("MISI results written to ", output_file_name)
    return result_df
end