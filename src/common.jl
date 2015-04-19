### Common types

# type parameters:
#   T: element type
#   N: the number of dimensions
#   M: contiguous rank
#
# Note: M is the maximum dimension such that
# slices up to this dimension are contiguous.
#
# For example, given a 3D contiguous array a,
# the contiguous rank of a is 3, that of
# view(a, :, :, 1:3) is 2, and that of
# view(a, :, 1:2, 1:3) is 1, etc.
#
# This rank plays a key role in efficient
# linear indexing and type-stable subview
# calculation.
#
abstract ArrayView{T,N,M} <: DenseArray{T,N}

# a type for indicating contiguous rank (statically)
type ContRank{M} end

## auxiliary union types to simplify method definition
## (for internal use only)

typealias Subs Union(Real,Colon,Range)
typealias SubsNC Union(Real,Range)
typealias SubsRange Union(Colon,Range)


### Common methods

contiguousrank{T,N,M}(a::ArrayView{T,N,M}) = M
contrank{T,N}(a::Array{T,N}) = ContRank{N}
contrank{T,N,M}(a::ArrayView{T,N,M}) = ContRank{M}

getdim{N}(s::NTuple{N,Int}, d::Integer) =
    (d > 0 || error("dimension out of range."); d <= N ? s[d] : 1)
size{T,N}(a::ArrayView{T,N}, d::Integer) = getdim(size(a), d)

pointer(a::ArrayView) = pointer(parent(a), offset(a)+1)
if VERSION < v"0.4.0-dev+3768"
    convert{T}(::Type{Ptr{T}}, a::ArrayView{T}) = pointer(a)
else
    unsafe_convert{T}(::Type{Ptr{T}}, a::ArrayView{T}) = pointer(a)
end

similar{T}(a::ArrayView{T}) = Array(T, size(a))
similar{T}(a::ArrayView{T}, dims::Dims) = Array(T, dims)
similar{T}(a::ArrayView, ::Type{T}, dims::Dims) = Array(T, dims)



### Common indexing functions

# Note: each subtype of ArrayView should implement uindex methods,
# which getindex and setindex! rely on to locate the element position

# getindex

getindex(a::ArrayView) = getindex(a.arr, a.offset + 1)

getindex(a::ArrayView, i::Int) = getindex(a.arr, uindex(a, i))
getindex(a::ArrayView, i1::Int, i2::Int) = getindex(a.arr, uindex(a, i1, i2))
getindex(a::ArrayView, i1::Int, i2::Int, i3::Int) =
    getindex(a.arr, uindex(a, i1, i2, i3))
getindex(a::ArrayView, i1::Int, i2::Int, i3::Int, i4::Int) =
    getindex(a.arr, uindex(a, i1, i2, i3, i4))
getindex(a::ArrayView, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    getindex(a.arr, uindex(a, i1, i2, i3, i4, i5))
getindex(a::ArrayView, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, i6::Int, I::Int...) =
    getindex(a.arr, uindex(a, i1, i2, i3, i4, i5, i6, I...))

getindex(a::ArrayView, i::Real) = getindex(a, to_index(i))
getindex(a::ArrayView, i1::Real, i2::Real) = getindex(a, to_index(i1), to_index(i2))
getindex(a::ArrayView, i1::Real, i2::Real, i3::Real) =
    getindex(a, to_index(i1), to_index(i2), to_index(i3))
getindex(a::ArrayView, i1::Real, i2::Real, i3::Real, i4::Real) =
    getindex(a, to_index(i1), to_index(i2), to_index(i3), to_index(i4))
getindex(a::ArrayView, i1::Real, i2::Real, i3::Real, i4::Real, i5::Real) =
    getindex(a, to_index(i1), to_index(i2), to_index(i3), to_index(i4), to_index(i5))
getindex(a::ArrayView, i1::Real, i2::Real, i3::Real, i4::Real, i5::Real, i6::Real, I::Int...) =
    getindex(a, to_index(i1), to_index(i2), to_index(i3),
                to_index(i4), to_index(i5), to_index(i6), I...)

# setindex!

setindex!{T}(a::ArrayView{T}, v, i::Int) = setindex!(a.arr, convert(T, v), uindex(a, i))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int, i3::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2, i3))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int, i3::Int, i4::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2, i3, i4))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2, i3, i4, i5))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, i6::Int, I::Int...) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2, i3, i4, i5, i6, I...))

setindex!(a::ArrayView, v, i::Real) = setindex!(a, v, to_index(i))
setindex!(a::ArrayView, v, i1::Real, i2::Real) = setindex!(a, v, to_index(i1), to_index(i2))
setindex!(a::ArrayView, v, i1::Real, i2::Real, i3::Real) =
    setindex!(a, v, to_index(i1), to_index(i2), to_index(i3))
setindex!(a::ArrayView, v, i1::Real, i2::Real, i3::Real, i4::Real) =
    setindex!(a, v, to_index(i1), to_index(i2), to_index(i3), to_index(i4))
setindex!(a::ArrayView, v, i1::Real, i2::Real, i3::Real, i4::Real, i5::Real) =
    setindex!(a, v, to_index(i1), to_index(i2), to_index(i3), to_index(i4), to_index(i5))
setindex!(a::ArrayView, v, i1::Real, i2::Real, i3::Real, i4::Real, i5::Real, i6::Real) =
    setindex!(a, v, to_index(i1), to_index(i2), to_index(i3),
                    to_index(i4), to_index(i5), to_index(i6))
setindex!(a::ArrayView, v, i1::Real, i2::Real, i3::Real, i4::Real, i5::Real, i6::Real, I::Int...) =
    setindex!(a, v, to_index(i1), to_index(i2), to_index(i3),
                    to_index(i4), to_index(i5), to_index(i6), I...)
