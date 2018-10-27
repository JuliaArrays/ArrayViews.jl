using ArrayViews, Test
import ArrayViews: ContRank

### Auxiliary functions

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

function strides_e1(s, m::Int)
    n = length(s)
    @assert m < n
    ss = zeros(Int, n)

    u = 1
    for i = 1:n
        if i <= m
            ss[i] = u
        else
            u += 1
            ss[i] = u
        end
        u *= s[i]
    end
    return tuple(ss...)
end

function _ofs(ss::NTuple{N,Int}, subs::NTuple{K,Int}) where {N,K}
    r = 0
    for i = 1:N
        r += ss[i] * (subs[i] - 1)
    end
    # println("ss = $ss, subs = $subs, r = $r")
    return r
end

function _ofs(siz::NTuple{N,Int}, ss::NTuple{N,Int}, subs::NTuple{K,Int}) where {N,K}
    # println("siz = $siz, ss = $ss, subs = $subs")
    if K >= N
        _ofs(ss, subs)
    else
        subs_ = (K == 1 ? ind2sub(siz, subs[1]) :
                          tuple(subs[1:K-1]..., ind2sub(siz[K:N], subs[K])...))::NTuple{N,Int}
        _ofs(ss, subs_)
    end::Int
end


function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{1,Int}) where T
    n = siz[1]
    @test T[v[i] for i = 1:n] == src[o+(1:n)]
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{2,Int}) where T
    d1, d2 = siz
    @test T[v[i1,i2] for i1=1:d1, i2=1:d2] == reshape(src[o+(1:d1*d2)], (d1, d2))
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{3,Int}) where T
    d1, d2, d3 = siz
    sr = reshape(src[o+(1:prod(siz))], (d1, d2, d3))
    vr = T[v[i1,i2,i3] for i1=1:d1, i2=1:d2, i3=1:d3]
    @test vr == sr
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{4,Int}) where T
    d1, d2, d3, d4 = siz
    sr = reshape(src[o+(1:prod(siz))], (d1, d2, d3, d4))
    vr = T[v[i1,i2,i3,i4] for i1=1:d1, i2=1:d2, i3=1:d3, i4=1:d4]
    @test vr == sr
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{5,Int}) where T
    d1, d2, d3, d4, d5 = siz
    sr = reshape(src[o+(1:prod(siz))], (d1, d2, d3, d4, d5))
    vr = T[v[i1,i2,i3,i4,i5] for i1=1:d1, i2=1:d2, i3=1:d3, i4=1:d4, i5=1:d5]
    @test vr == sr
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{1,Int}, ss) where T
    vsiz = size(v)
    n = siz[1]
    sr = T[src[o + 1 + _ofs(vsiz, ss, (i,))] for i = 1:n]
    vr = T[v[i] for i = 1:n]
    @test vr == sr
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{2,Int}, ss) where T
    vsiz = size(v)
    d1, d2 = siz
    sr = T[src[o + 1 + _ofs(vsiz, ss, (i1, i2))] for i1=1:d1, i2=1:d2]
    vr = T[v[i1, i2] for i1 = 1:d1, i2=1:d2]
    @test vr == sr
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{3,Int}, ss) where T
    vsiz = size(v)
    d1, d2, d3 = siz
    sr = T[src[o + 1 + _ofs(vsiz, ss, (i1, i2, i3))] for i1=1:d1, i2=1:d2, i3=1:d3]
    vr = T[v[i1, i2, i3] for i1 = 1:d1, i2=1:d2, i3=1:d3]
    @test vr == sr
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{4,Int}, ss) where T
    vsiz = size(v)
    d1, d2, d3, d4 = siz
    sr = T[src[o + 1 + _ofs(vsiz, ss, (i1, i2, i3, i4))] for i1=1:d1, i2=1:d2, i3=1:d3, i4=1:d4]
    vr = T[v[i1, i2, i3, i4] for i1 = 1:d1, i2=1:d2, i3=1:d3, i4=1:d4]
    @test vr == sr
end

function verify_elements(src::Array{T}, o::Int, v::AbstractArray, siz::NTuple{5,Int}, ss) where T
    vsiz = size(v)
    d1, d2, d3, d4, d5 = siz
    sr = T[src[o + 1 + _ofs(vsiz, ss, (i1, i2, i3, i4, i5))] for i1=1:d1, i2=1:d2, i3=1:d3, i4=1:d4, i5=1:d5]
    vr = T[v[i1, i2, i3, i4, i5] for i1 = 1:d1, i2=1:d2, i3=1:d3, i4=1:d4, i5=1:d5]
    @test vr == sr
end


function verify_cview(VType, src::Array{T}, o::Int, siz::NTuple{N,Int}) where {T,N}
    @assert o + prod(siz) <= length(src)
    v = VType(src, o, siz)
    @test isa(v, VType{T,N})
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

function verify_sview(VType, src::Array{T}, o::Int, siz::NTuple{N,Int}, cr::Type{ContRank{M}}, ss::NTuple{N,Int}) where {T,N,M}
    # ss: strides
    @assert ss[1] >= 1
    for d = 2:N
        @assert ss[d] >= ss[d-1] * siz[d-1]
    end

    @assert o + ss[N] * siz[N]  <= length(src)
    v = VType(src, o, siz, cr, ss)
    @test isa(v, VType{T,N,M})
    @test eltype(v) == T
    @test ndims(v) == N
    @test size(v) == siz
    @test length(v) == prod(siz)
    for d = 1:N
        @test size(v,d) == siz[d]
    end
    @test iscontiguous(v) == false
    @test contiguousrank(v) == M

    @test strides(v) == ss
    for d = 1:N
        @test stride(v,d) == ss[d]
    end

    for k = 1:min(N+1,5)
        verify_elements(src, o, v, reshape_size(siz, k), ss)
    end
end


### main cases

src = Float64[1.0 * x for x = 1:4096]

for N = 1:5
    println("    -- testing ContiguousView{T,$N}")
    siz = tuple((6:-1:(6-N+1))...)
    verify_cview(ContiguousView, src, 0, siz)
    verify_cview(ContiguousView, src, 8, siz)
end

for N = 1:5
    println("    -- testing UnsafeContiguousView{T,$N}")
    siz = tuple((6:-1:(6-N+1))...)
    verify_cview(UnsafeContiguousView, src, 0, siz)
    verify_cview(UnsafeContiguousView, src, 8, siz)
end

for N = 1:5, M = 0:N-1
    println("    -- testing StridedView{T,$N,$M}")
    siz = tuple((6:-1:(6-N+1))...)
    ss = strides_e1(siz, M)
    verify_sview(StridedView, src, 0, siz, ContRank{M}, ss)
    verify_sview(StridedView, src, 8, siz, ContRank{M}, ss)
end

for N = 1:5, M = 0:N-1
    println("    -- testing UnsafeStridedView{T,$N,$M}")
    siz = tuple((6:-1:(6-N+1))...)
    ss = strides_e1(siz, M)
    verify_sview(UnsafeStridedView, src, 0, siz, ContRank{M}, ss)
    verify_sview(UnsafeStridedView, src, 8, siz, ContRank{M}, ss)
end
