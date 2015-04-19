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
