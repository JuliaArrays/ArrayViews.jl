# benchmarking

using ArrayViews

# auxiliary functions

mps(a::AbstractArray, rtimes::Int, et::Float64) = (length(a) * 1.0e-6) * rtimes / et

myrepr(r::Ranges) = repr(r)
myrepr(r::Real) = repr(r)
myrepr(r::Colon) = ":"


# timing functions

function time_view1d(a::AbstractArray, rtimes::Int)
    # warm up
    n::Int = length(a)
    for i = 1:n
        @inbounds a[i]
    end

    # benchmark
    et = @elapsed for t = 1 : rtimes
        for i = 1:n
            @inbounds a[i]
        end
    end
    return et
end

function time_view2d(a::AbstractArray, rtimes::Int)
    # warm up
    m::Int = size(a, 1)
    n::Int = size(a, 2)
    for j = 1:n, i = 1:m
        @inbounds a[i,j]
    end

    # benchmark
    et = @elapsed for t = 1 : rtimes
        for j = 1:n, i = 1:m
            @inbounds a[i,j]
        end
    end
    return et
end

function perf_view(a::Array, i1; rtimes::Int=200000)
    et_s = time_view1d(sub(a, i1), rtimes)
    et_v = time_view1d(view(a, i1), rtimes)

    v = view(a, i1)
    mps_s = mps(v, rtimes, et_s)
    mps_v = mps(v, rtimes, et_v)

    @printf("%-18s:   %10.3f MPS   %10.3f MPS |  gain = %6.3fx\n", 
        "[$(myrepr(i1))]", mps_s, mps_v, mps_v / mps_s)
end

function perf_view(a::Array, i1, i2; rtimes::Int=200000)
    et_s = time_view2d(sub(a, i1, i2), rtimes)
    et_v = time_view2d(view(a, i1, i2), rtimes)

    v = view(a, i1, i2)
    mps_s = mps(v, rtimes, et_s)
    mps_v = mps(v, rtimes, et_v)    

    @printf("%-18s:   %10.3f MPS   %10.3f MPS |  gain = %6.3fx\n", 
        "[$(myrepr(i1)), $(myrepr(i2))]", mps_s, mps_v, mps_v / mps_s)
end



# benchmarks

println("Indexing                sub              view")
println("-----------------------------------------------------------------------")

const a1 = rand(1024)

gc_disable()

perf_view(a1, :)
perf_view(a1, 1:1024)
perf_view(a1, 1:2:1024)

gc_enable()

const a2 = rand(32, 32)

gc_disable()

perf_view(a2, :, :)
perf_view(a2, :, 1:32)
perf_view(a2, :, 1:2:32)

perf_view(a2, 1:30, :)
perf_view(a2, 1:30, 1:32)
perf_view(a2, 1:30, 1:2:32)

perf_view(a2, 1:2:30, :)
perf_view(a2, 1:2:30, 1:32)
perf_view(a2, 1:2:30, 1:2:32)

gc_enable()



