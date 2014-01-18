# generic view types


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

eltype{T}(a::ArrayView{T}) = T
ndims{T,N}(a::ArrayView{T,N}) = N
contiguousrank{T,N,M}(a::ArrayView{T,N,M}) = M

# size

getdim{N}(s::NTuple{N,Int}, d::Integer) = (d > 0 || error("dimension out of range."); d <= N ? s[d] : 1)
size{T,N}(a::ArrayView{T,N}, d::Integer) = getdim(size(a), d);

# getindex

getindex(a::ArrayView, i::Int) = getindex(a, to_index(i))

getindex(a::ArrayView, i0::Int, i1::Int) = getindex(a, to_index(i0), to_index(i1))

getindex(a::ArrayView, i0::Int, i1::Int, i2::Int) = 
    getindex(a, to_index(i0), to_index(i1), to_index(i2))

getindex(a::ArrayView, i0::Int, i1::Int, i2::Int, i3::Int) = 
    getindex(a, to_index(i0), to_index(i1), to_index(i2), to_index(i3))

getindex(a::ArrayView, i0::Int, i1::Int, i2::Int, i3::Int, i4::Int) = 
    getindex(a, to_index(i0), to_index(i1), to_index(i2), to_index(i3), to_index(i4))

getindex(a::ArrayView, i0::Int, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = 
    getindex(a, to_index(i0), to_index(i1), to_index(i2), to_index(i3), to_index(i4), to_index(i5))

getindex(a::ArrayView, i0::Int, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, I::Int...) = 
    getindex(a, to_index(i0), to_index(i1), to_index(i2), to_index(i3), to_index(i4), to_index(i5), I...)


getindex(a::ArrayView, i::Int) = arrayref(a.arr, uindex(a, i))
getindex(a::ArrayView, i0::Int, i1::Int) = arrayref(a.arr, uindex(a, i0, i1))
getindex(a::ArrayView, i0::Int, i1::Int, i2::Int) = arrayref(a.arr, uindex(a, i0, i1, i2))
getindex(a::ArrayView, i0::Int, i1::Int, i2::Int, i3::Int) =  arrayref(a.arr, uindex(a, i0, i1, i2, i3))
getindex(a::ArrayView, i0::Int, i1::Int, i2::Int, i3::Int, i4::Int) = arrayref(a.arr, uindex(i0, i1, i2, i3, i4))
getindex(a::ArrayView, i0::Int, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, I::Int...) = 
    arrayref(a.arr, uindex(a, i0, i1, i2, i3, i4, i5, I...))

