# benchmarking

using ArrayViews

# auxiliary functions

mps(a::AbstractArray, rtimes::Int, et::Float64) = length(a) * 1.0e-6 * rtimes / et

myrepr(r::Range) = repr(r)
myrepr(r::Real) = repr(r)
myrepr(r::Colon) = ":"


# timing functions

function time_view1d{T}(a::AbstractArray{T}, rtimes::Int)
    # warm up
    n::Int = length(a)
    for i = 1:n
        @inbounds a[i]
    end

    # benchmark
    s = zero(T)
    et = @elapsed for t = 1 : rtimes
        for i = 1:n
            @inbounds s += a[i]
        end
    end
    return (et, s)
end

function time_view2d{T}(a::AbstractArray{T}, rtimes::Int)
    # warm up
    m::Int = size(a, 1)
    n::Int = size(a, 2)
    for j = 1:n, i = 1:m
        @inbounds a[i,j]
    end

    # benchmark
    s = zero(T)
    et = @elapsed for t = 1 : rtimes
        for j = 1:n, i = 1:m
            @inbounds s += a[i,j]
        end
    end
    return (et, s)
end

function time_view3d{T}(a::AbstractArray{T}, rtimes::Int)
    # warm up
    m::Int = size(a, 1)
    n::Int = size(a, 2)
    k::Int = size(a, 3)
    for l = 1:k, j = 1:n, i = 1:m
        @inbounds a[i,j,l]
    end

    # benchmark
    s = zero(T)
    et = @elapsed for t = 1 : rtimes
        for l = 1:k, j = 1:n, i = 1:m
            @inbounds s += a[i,j,l]
        end
    end
    return (et, s)
end


function perf_view(a::Array, i1; rtimes::Int=100000)
    et_s, _ = time_view1d(sub(a, i1), rtimes)
    et_v, _ = time_view1d(view(a, i1), rtimes)
    et_u, _ = time_view1d(unsafe_view(a, i1), rtimes)

    v = view(a, i1)
    mps_s = mps(v, rtimes, et_s)
    mps_v = mps(v, rtimes, et_v)
    mps_u = mps(v, rtimes, et_u)

    @printf("%-24s:   %10.3f MPS   %10.3f MPS (%6.3fx)   %10.3f MPS (%6.3fx)\n",
        "[$(myrepr(i1))]", mps_s, mps_v, mps_v / mps_s, mps_u, mps_u / mps_s)
end

function perf_view(a::Array, i1, i2; rtimes::Int=100000)
    et_s, _ = time_view2d(sub(a, i1, i2), rtimes)
    et_v, _ = time_view2d(view(a, i1, i2), rtimes)
    et_u, _ = time_view2d(unsafe_view(a, i1, i2), rtimes)

    v = view(a, i1, i2)
    mps_s = mps(v, rtimes, et_s)
    mps_v = mps(v, rtimes, et_v)
    mps_u = mps(v, rtimes, et_u)

    @printf("%-24s:   %10.3f MPS   %10.3f MPS (%6.3fx)   %10.3f MPS (%6.3fx)\n",
        "[$(myrepr(i1)), $(myrepr(i2))]", mps_s, mps_v, mps_v / mps_s, mps_u, mps_u / mps_s)
end

function perf_view(a::Array, i1, i2, i3; rtimes::Int=100000)
    et_s, _ = time_view3d(sub(a, i1, i2, i3), rtimes)
    et_v, _ = time_view3d(view(a, i1, i2, i3), rtimes)
    et_u, _ = time_view3d(unsafe_view(a, i1, i2, i3), rtimes)

    v = view(a, i1, i2, i3)
    mps_s = mps(v, rtimes, et_s)
    mps_v = mps(v, rtimes, et_v)
    mps_u = mps(v, rtimes, et_u)

    @printf("%-24s:   %10.3f MPS   %10.3f MPS (%6.3fx)   %10.3f MPS (%6.3fx)\n",
        "[$(myrepr(i1)), $(myrepr(i2)), $(myrepr(i3))]", mps_s, mps_v, mps_v / mps_s, mps_u, mps_u / mps_s)
end

# benchmarks

println("Indexing                      sub              view                       unsafe_view")
println("--------------------------------------------------------------------------------------------------")

const a1 = rand(1024)

gc_disable()

println("1D views")
perf_view(a1, :)
perf_view(a1, 1:1024)
perf_view(a1, 1:2:1024)
println()

gc_enable()

const a2 = rand(32, 32)

gc_disable()

println("2D views")
perf_view(a2, :, :)
perf_view(a2, :, 1:32)
perf_view(a2, :, 1:2:32)

perf_view(a2, 1:30, :)
perf_view(a2, 1:30, 1:32)
perf_view(a2, 1:30, 1:2:32)

perf_view(a2, 1:2:30, :)
perf_view(a2, 1:2:30, 1:32)
perf_view(a2, 1:2:30, 1:2:32)
println()

gc_enable()

const a3 = rand(16, 8, 8)

gc_disable()

println("3D views")
perf_view(a3, :, :, :)
perf_view(a3, :, :, 1:8)
perf_view(a3, :, :, 1:2:8)

perf_view(a3, :, 1:8, :)
perf_view(a3, :, 1:8, 1:8)
perf_view(a3, :, 1:8, 1:2:8)

perf_view(a3, :, 1:2:8, :)
perf_view(a3, :, 1:2:8, 1:8)
perf_view(a3, :, 1:2:8, 1:2:8)

perf_view(a3, 1:16, :, :)
perf_view(a3, 1:16, :, 1:8)
perf_view(a3, 1:16, :, 1:2:8)

perf_view(a3, 1:16, 1:8, :)
perf_view(a3, 1:16, 1:8, 1:8)
perf_view(a3, 1:16, 1:8, 1:2:8)

perf_view(a3, 1:16, 1:2:8, :)
perf_view(a3, 1:16, 1:2:8, 1:8)
perf_view(a3, 1:16, 1:2:8, 1:2:8)

perf_view(a3, 1:2:16, :, :)
perf_view(a3, 1:2:16, :, 1:8)
perf_view(a3, 1:2:16, :, 1:2:8)

perf_view(a3, 1:2:16, 1:8, :)
perf_view(a3, 1:2:16, 1:8, 1:8)
perf_view(a3, 1:2:16, 1:8, 1:2:8)

perf_view(a3, 1:2:16, 1:2:8, :)
perf_view(a3, 1:2:16, 1:2:8, 1:8)
perf_view(a3, 1:2:16, 1:2:8, 1:2:8)
println()

gc_enable()
