struct MISIResult{T<:Real}
    misi::T 
    message::String
    misi_global::T
    misi_spline::T
end

function MISIResult(msg::String)
    return MISIResult(NaN, msg, NaN, NaN)
end