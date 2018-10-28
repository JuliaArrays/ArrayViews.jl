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
abstract type StridedArrayView{T,N,M} <: DenseArray{T,N} end
abstract type ArrayView{T,N,M} <: StridedArrayView{T,N,M} end
abstract type UnsafeArrayView{T,N,M} <: StridedArrayView{T,N,M} end

# a type for indicating contiguous rank (statically)
mutable struct ContRank{M} end

## auxiliary union types to simplify method definition
## (for internal use only)

const Subs = Union{Real,Colon,AbstractRange}
const SubsNC = Union{Real,AbstractRange}
const SubsRange = Union{Colon,AbstractRange}


### Common methods

iscontiguous(a::DenseArray) = false
iscontiguous(a::Array) = true

offset(a::Array) = 0

contiguousrank(a::StridedArrayView{T,N,M}) where {T,N,M} = M

contrank(a::Array{T,N}) where {T,N} = ContRank{N}
contrank(a::StridedArrayView{T,N,M}) where {T,N,M} = ContRank{M}

length(a::StridedArrayView) = a.len
size(a::StridedArrayView) = a.shp

getdim(s::NTuple{N,Int}, d::Integer) where {N} = (1 <= d <= N ? s[d] : 1)
size(a::StridedArrayView{T,N}, d::Integer) where {T,N} = getdim(size(a), d)

## pointer conversion

unsafe_convert(::Type{Ptr{T}}, a::StridedArrayView{T}) where {T} = pointer(a)

## Create similar array

similar(a::StridedArrayView, ::Type{T}, dims::Dims) where {T} = Array{T}(undef, dims)
