
# use ContiguousView when contiguousness can be determined statically
immutable ContiguousView{T,N,Arr<:Array} <: ArrayView{T,N,N}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
end

contiguous_view{T,N}(arr::Array{T}, offset::Int, shp::NTuple{N,Int}) =
    ContiguousView{T,N,typeof(arr)}(arr, offset, prod(shp), shp)

contiguous_view(arr::Array, shp::Dims) = contiguous_view(arr, 0, shp)

contiguous_view(v::ContiguousView, shp::Dims) = contiguous_view(v.arr, v.offset, shp)
contiguous_view(v::ContiguousView, offset::Int, shp::Dims) = contiguous_view(v.arr, offset + v.offset, shp)


### Methods

offset(a::Array) = 0

parent(a::ContiguousView) = a.arr
offset(a::ContiguousView) = a.offset
length(a::ContiguousView) = a.len
size(a::ContiguousView) = a.shp

iscontiguous(a::ContiguousView) = true

strides{T}(a::ContiguousView{T,1}) = (1,)
strides{T}(a::ContiguousView{T,2}) = (1, a.shp[1])
strides{T}(a::ContiguousView{T,3}) = (1, a.shp[1], a.shp[1] * a.shp[2])
strides{T}(a::ContiguousView{T,4}) =
    (1, a.shp[1], a.shp[1] * a.shp[2], a.shp[1] * a.shp[2] * a.shp[3])

function strides{T,N}(a::ContiguousView{T,N})
    s = Array(Int, N)
    s[1] = p = 1
    d = 1
    while d < N
        p *= a.shp[d]
        d += 1
        s[d] = p
    end
    return tuple(s...)::NTuple{N,Int}
end

stride{T}(a::ContiguousView{T,1}, d::Integer) =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 : length(a))::Int

stride{T}(a::ContiguousView{T,2}, d::Integer) =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] : length(a))::Int

stride{T}(a::ContiguousView{T,3}, d::Integer) =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] :
     d == 3 ? a.shp[1] * a.shp[2] : length(a))::Int

stride{T,N}(a::ContiguousView{T,N}, d::Integer) =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] :
     d <= N ? *(a.shp[1:d-1]...) : length(a))::Int


uget(a::ContiguousView, i::Int) = getindex(a.arr, a.offset + i)
uset!{T}(a::ContiguousView{T}, v::T, i::Int) = setindex!(a.arr, v, a.offset + i)


# use StridedView otherwise
# condition: M <= N
immutable StridedView{T,N,M,Arr<:Array} <: ArrayView{T,N,M}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
    strides::NTuple{N,Int}
end

function strided_view{T,N,M}(arr::Array{T}, offset::Int, shp::NTuple{N,Int},
                             ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M <= N
    StridedView{T,N,M,typeof(arr)}(arr, offset, prod(shp), shp, strides)
end

function strided_view{T,N,M}(arr::Array{T}, shp::NTuple{N,Int},
                             ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M <= N
    StridedView{T,N,M,typeof(arr)}(arr, 0, prod(shp), shp, strides)
end


### Methods

parent(a::StridedView) = a.arr
offset(a::StridedView) = a.offset
length(a::StridedView) = a.len
size(a::StridedView) = a.shp

strides(a::StridedView) = a.strides
stride{T,N}(a::StridedView{T,N}, d::Integer) =
    (1 <= d <= N || error("dimension out of range.");
     a.strides[d])

iscontiguous{T,N}(a::StridedView{T,N,N}) = true;
iscontiguous{T,N}(a::StridedView{T,N,N}) = true;
iscontiguous{T,N}(a::StridedView{T,N}) = _iscontiguous(a.shp, a.strides)

_iscontiguous(shp::NTuple{0,Int}, strides::NTuple{0,Int}) = true
_iscontiguous(shp::NTuple{1,Int}, strides::NTuple{1,Int}) = (strides[1] == 1)
_iscontiguous(shp::NTuple{2,Int}, strides::NTuple{2,Int}) =
    (strides[1] == 1 && strides[2] == shp[1])
_iscontiguous(shp::NTuple{3,Int}, strides::NTuple{3,Int}) =
    (strides[1] == 1 &&
     strides[2] == shp[1] &&
     strides[3] == shp[1] * shp[2])

function _iscontiguous{N}(shp::NTuple{N,Int}, strides::NTuple{N,Int})
    s = 1
    for i = 1:N
        if strides[i] != s
            return false
        end
        s *= shp[i]
    end
    return true
end

uget(a::StridedView, i::Int) = getindex(a.arr, a.offset + i)
uset!{T}(a::StridedView{T}, v::T, i::Int) = setindex!(a.arr, v, a.offset + i)
