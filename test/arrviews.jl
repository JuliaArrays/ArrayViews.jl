using ArrayViews
using Base.Test


src = rand(2048)

function reshape_size(s, n::Int)
    d = length(s)
    r = if n < d
        tuple(s[1:n-1]..., prod(s[n:d]))
    elseif n > d
        tuple(s..., ones(Int,n-d)...)
    else
        s
    end
    @assert length(r) == n && prod(r) == prod(s)
    return r
end


function verify_elements{T}(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{1,Int})
    n = siz[1]
    @test T[v[i] for i = 1:n] == src[o+(1:n)]
end

function verify_elements{T}(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{2,Int})
    d1, d2 = siz
    @test T[v[i1,i2] for i1=1:d1, i2=1:d2] == reshape(src[o+(1:d1*d2)], (d1, d2))
end

function verify_elements{T}(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{3,Int})
    d1, d2, d3 = siz
    sr = reshape(src[o+(1:prod(siz))], (d1, d2, d3))
    vr = T[v[i1,i2,i3] for i1=1:d1, i2=1:d2, i3=1:d3]
    @test vr == sr
end

function verify_elements{T}(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{4,Int})
    d1, d2, d3, d4 = siz
    sr = reshape(src[o+(1:prod(siz))], (d1, d2, d3, d4))
    vr = T[v[i1,i2,i3,i4] for i1=1:d1, i2=1:d2, i3=1:d3, i4=1:d4]
    @test vr == sr
end

function verify_elements{T}(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{5,Int})
    d1, d2, d3, d4, d5 = siz
    sr = reshape(src[o+(1:prod(siz))], (d1, d2, d3, d4, d5))
    vr = T[v[i1,i2,i3,i4,i5] for i1=1:d1, i2=1:d2, i3=1:d3, i4=1:d4, i5=1:d5]
    @test vr == sr
end


function verify_cview{T,N}(src::Array{T}, o::Int, siz::NTuple{N,Int})
    @assert o + prod(siz) <= length(src)
    v = contiguous_view(src, o, siz)
    @test isa(v, ContiguousView{T,N})
    @test eltype(v) == T
    @test ndims(v) == N
    @test size(v) == siz
    @test length(v) == prod(siz)
    for d = 1:N
        @test size(v,d) == siz[d]
    end
    # @test offset(v) == o
    @test iscontiguous(v)
    @test contiguousrank(v) == N

    strides_arr = zeros(Int, N)
    strides_arr[1] = 1
    for d = 2:N
        strides_arr[d] = strides_arr[d-1] * siz[d-1]
    end
    strides_tup = tuple(strides_arr...)

    @test strides(v) == strides_tup
    for d = 1:N
        @test stride(v,d) == strides_tup[d]
    end

    for k = 1:min(N+1,5)
        verify_elements(src, o, v, reshape_size(siz, k))
    end
end


for N = 1:5
    println("    -- testing ContiguousView{T,$N}")
    siz = tuple((6:-1:(6-N+1))...)
    verify_cview(src, 0, siz)
    verify_cview(src, 8, siz)
end
