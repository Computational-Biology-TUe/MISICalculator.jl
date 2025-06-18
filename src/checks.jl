function peak_at_final_timepoint(glucose)
    return argmax(glucose) == length(glucose)
end

function flat_glucose_curve(glucose; threshold=0.5)
    return (maximum(glucose) - glucose[1]) < threshold
end

function large_rebound(glucose; threshold=0.5)
    peak_index = argmax(glucose)
    global_minimum = minimum(glucose[peak_index:end])

    glucose_trajectory = glucose[peak_index:end]
    if length(glucose_trajectory) < 3
        return false  # Not enough data points to determine a rebound
    end

    # Find rebounds
    last_peak = 1; new_peak = false
    for i in eachindex(glucose_trajectory)[2:end]
        if glucose_trajectory[i] > glucose_trajectory[i-1] && !new_peak
            new_peak = true
        elseif glucose_trajectory[i] < glucose_trajectory[i-1] && new_peak

            local_peak = glucose_trajectory[i-1]
            local_minimum = minimum(glucose_trajectory[last_peak+1:i-1])
            if (local_peak - local_minimum > threshold) && (local_minimum - global_minimum > threshold)
                # Significant rebound detected
                println("Rebound detected at index $(i-1): peak = $local_peak, minimum = $local_minimum")
                return true
            end
            # Reset for the next peak
            last_peak = i-1
            new_peak = false
        end

    end
    return false  # No significant rebound found
end

function hypoglycemia(glucose; threshold=3.5)
    return any(glucose .< threshold)
end

function missing_values(x)
    return any(ismissing.(x))
end

no_rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 1.0, 0.1]
almost_rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 3.3, 1.5, 0.1]
rebound = [0.0, 1.0, 2.0, 5.0, 3.0, 2.0, 2.6, 0.1]
rebound_2 = [0.0, 1.0, 2.0, 5.0, 3.0, 3.3, 1.1, 1.5, 2.5, 2.0, 0.1] 
