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
abstract StridedArrayView{T,N,M} <: DenseArray{T,N}
abstract ArrayView{T,N,M} <: StridedArrayView{T,N,M}
abstract UnsafeArrayView{T,N,M} <: StridedArrayView{T,N,M}

# a type for indicating contiguous rank (statically)
type ContRank{M} end

## auxiliary union types to simplify method definition
## (for internal use only)

typealias Subs Union(Real,Colon,Range)
typealias SubsNC Union(Real,Range)
typealias SubsRange Union(Colon,Range)


### Common methods

iscontiguous(a::AbstractArray) = false
iscontiguous(a::Array) = true

contiguousrank{T,N,M}(a::StridedArrayView{T,N,M}) = M

contrank{T,N}(a::Array{T,N}) = ContRank{N}
contrank{T,N,M}(a::StridedArrayView{T,N,M}) = ContRank{M}

getdim{N}(s::NTuple{N,Int}, d::Integer) = (1 <= d <= N ? s[d] : 1)
size{T,N}(a::ArrayView{T,N}, d::Integer) = getdim(size(a), d)

## Get pointer

pointer(a::ArrayView) = pointer(parent(a), offset(a)+1)
pointer(a::UnsafeArrayView) = a.ptr

if VERSION < v"0.4.0-dev+3768"
    convert{T}(::Type{Ptr{T}}, a::StridedArrayView{T}) = pointer(a)
else
    unsafe_convert{T}(::Type{Ptr{T}}, a::StridedArrayView{T}) = pointer(a)
end

## Create similar array

similar{T}(a::StridedArrayView{T}) = Array(T, size(a))
similar{T}(a::StridedArrayView{T}, dims::Dims) = Array(T, dims)
similar{T}(a::StridedArrayView{T}, ::Type{T}, dims::Dims) = Array(T, dims)
