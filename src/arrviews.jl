### View types

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


# use StridedView otherwise
# condition: M < N
immutable StridedView{T,N,M,Arr<:Array} <: ArrayView{T,N,M}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
    strides::NTuple{N,Int}
end

function strided_view{T,N,M}(arr::Array{T}, offset::Int, shp::NTuple{N,Int},
                             ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M < N
    StridedView{T,N,M,typeof(arr)}(arr, offset, prod(shp), shp, strides)
end

function strided_view{T,N,M}(arr::Array{T}, shp::NTuple{N,Int},
                             ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M < N
    StridedView{T,N,M,typeof(arr)}(arr, 0, prod(shp), shp, strides)
end


### basic methods

parent(a::ArrayView) = a.arr
length(a::ArrayView) = a.len
size(a::ArrayView) = a.shp

uget(a::ArrayView, i::Int) = getindex(a.arr, a.offset + i)
uset!{T}(a::ArrayView{T}, v::T, i::Int) = setindex!(a.arr, v, a.offset + i)

offset(a::ArrayView) = a.offset
pointer(a::ArrayView) = pointer(parent(a), a.offset+1)
