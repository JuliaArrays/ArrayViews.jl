# benchmarking

using ArrayViews

function time_view1d(s::SubArray, v::ArrayView, rtimes::Int)
    # warm up
    n = length(v)
    @assert n == length(s)

    for i = 1:n
        @inbounds s[i]
    end
    for i = 1:n
        @inbounds v[i]
    end

    et_s = @elapsed for t = 1 : rtimes
        for i = 1:n 
            @inbounds s[i]
        end
    end

    et_v = @elapsed for t = 1 : rtimes
        for i = 1:n
            @inbounds v[i]
        end
    end

    mps_s = (n / 1.0e6) * rtimes / et_s
    mps_v = (n / 1.0e6) * rtimes / et_v

    return (mps_s, mps_v)
end

function time_view2d(s::SubArray, v::ArrayView, rtimes::Int)
    # warm up
    m = size(v, 1)
    n = size(v, 2)
    @assert size(s) == (m, n)

    for j = 1:n, i = 1:m
        @inbounds s[i,j]
    end
    for j = 1:n, i = 1:m
        @inbounds v[i,j]
    end

    et_s = @elapsed for t = 1 : rtimes
        for j = 1:n, i = 1:m
            @inbounds s[i,j]
        end
    end

    et_v = @elapsed for t = 1 : rtimes
        for j = 1:n, i = 1:m
            @inbounds v[i,j]
        end
    end

    mps_s = (n / 1.0e6) * rtimes / et_s
    mps_v = (n / 1.0e6) * rtimes / et_v

    return (mps_s, mps_v)
end


function perf_view(a::Array, title, i1, rtimes::Int)
    (mps_s, mps_v) = time_view1d(sub(a, i1), view(a, i1), rtimes)
    @printf("%-16s:   %10.3f MPS   %10.3f MPS |  gain = %6.3fx\n", 
        "[$title]", mps_s, mps_v, mps_v / mps_s)
end

function perf_view(a::Array, title, i1, i2, rtimes::Int)
    (mps_s, mps_v) = time_view2d(sub(a, i1, i2), view(a, i1, i2), rtimes)
    @printf("%-16s:   %10.3f MPS   %10.3f MPS |  gain = %6.3fx\n", 
        "[$title]", mps_s, mps_v, mps_v / mps_s)
end



# benchmarks

const a1 = rand(512)

perf_view(a1, ":", :, 10^6)
perf_view(a1, "1:512", 1:512, 10^6)


const a2 = rand(32, 16)

perf_view(a2, ":,:", :, :, 200000)
perf_view(a2, ":,1:32", :, 1:32, 200000)




