
### Common indexing functions

# Note: each array view type should implement
#
#   - uget(a, i):       retrieve the i-th element w.r.t. the underlying base
#   - uset!(a, v, i):   set the value of the i-th element w.r.t. the underlying base
#

idx(i::Integer) = convert(Int, i)::Int
idx(i::Int) = i


### uindex (for non-contiguous views)

xoffset0(s::NTuple{1,Int}, i1::Int) = (i1-1) * s[1]
xoffset0(s::NTuple{2,Int}, i1::Int, i2::Int) = (i1-1) * s[1] + (i2-1) * s[2]
xoffset0(s::NTuple{3,Int}, i1::Int, i2::Int, i3::Int) =
    (i1-1) * s[1] + (i2-1) * s[2] + (i3-1) * s[3]
xoffset0(s::NTuple{4,Int}, i1::Int, i2::Int, i3::Int, i4::Int) =
    (i1-1) * s[1] + (i2-1) * s[2] + (i3-1) * s[3] + (i4-1) * s[4]
xoffset0(s::NTuple{5,Int}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    (i1-1) * s[1] + (i2-1) * s[2] + (i3-1) * s[3] + (i4-1) * s[4] + (i5-1) * s[5]

# for cases with s[1] == 1
#
xoffset(s::NTuple{1,Int}, i1::Int) = (i1-1)
xoffset(s::NTuple{2,Int}, i1::Int, i2::Int) = (i1-1) + (i2-1) * s[2]
xoffset(s::NTuple{3,Int}, i1::Int, i2::Int, i3::Int) =
    (i1-1) + (i2-1) * s[2] + (i3-1) * s[3]
xoffset(s::NTuple{4,Int}, i1::Int, i2::Int, i3::Int, i4::Int) =
    (i1-1) + (i2-1) * s[2] + (i3-1) * s[3] + (i4-1) * s[4]
xoffset(s::NTuple{5,Int}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    (i1-1) + (i2-1) * s[2] + (i3-1) * s[3] + (i4-1) * s[4] + (i5-1) * s[5]


# 1D

uindex{T}(a::NonContViews{T,1}, i1::Int) = 1 + xoffset(strides(a), i1)
uindex{T}(a::NonContViews{T,1,0}, i1::Int) = 1 + xoffset0(strides(a), i1)
uindex{T}(a::NonContViews{T,1}, i1::Int, i2::Int) = uindex(a, i1)
uindex{T}(a::NonContViews{T,1}, i1::Int, i2::Int, i3::Int) = uindex(a, i1)
uindex{T}(a::NonContViews{T,1}, i1::Int, i2::Int, i3::Int, i4::Int) = uindex(a, i1)
uindex{T}(a::NonContViews{T,1}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = uindex(a, i1)

# 2D

uindex{T}(a::NonContViews{T,2}, i1::Int) = ((j1, j2) = ind2sub(size(a), i1); uindex(a, j1, j2))

uindex{T}(a::NonContViews{T,2}, i1::Int, i2::Int) = 1 + xoffset(strides(a), i1, i2)
uindex{T}(a::NonContViews{T,2,0}, i1::Int, i2::Int) = 1 + xoffset0(strides(a), i1, i2)

uindex{T}(a::NonContViews{T,2}, i1::Int, i2::Int, i3::Int) = uindex(a, i1, i2)
uindex{T}(a::NonContViews{T,2}, i1::Int, i2::Int, i3::Int, i4::Int) = uindex(a, i1, i2)
uindex{T}(a::NonContViews{T,2}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = uindex(a, i1, i2)

# 3D

uindex{T}(a::NonContViews{T,3}, i1::Int) = ((j1, j2, j3) = ind2sub(size(a), i1); uindex(a, j1, j2, j3))
uindex{T}(a::NonContViews{T,3}, i1::Int, i2::Int) = ((j2, j3) = ind2sub(size(a)[2:3], i2); uindex(a, i1, j2, j3))

uindex{T}(a::NonContViews{T,3,0}, i1::Int, i2::Int, i3::Int) = 1 + xoffset0(strides(a), i1, i2, i3)
uindex{T}(a::NonContViews{T,3}, i1::Int, i2::Int, i3::Int) = 1 + xoffset(strides(a), i1, i2, i3)

uindex{T}(a::NonContViews{T,3}, i1::Int, i2::Int, i3::Int, i4::Int) = uindex(a, i1, i2, i3)
uindex{T}(a::NonContViews{T,3}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = uindex(a, i1, i2, i3)

# 4D

uindex{T}(a::NonContViews{T,4}, i1::Int) = ((j1, j2, j3, j4) = ind2sub(size(a), i1); uindex(a, j1, j2, j3, j4))
uindex{T}(a::NonContViews{T,4}, i1::Int, i2::Int) = ((j2, j3, j4) = ind2sub(size(a)[2:4], i2); uindex(a, i1, j2, j3, j4))
uindex{T}(a::NonContViews{T,4}, i1::Int, i2::Int, i3::Int) = ((j3, j4) = ind2sub(size(a)[3:4], i3); uindex(a, i1, i2, j3, j4))

uindex{T}(a::NonContViews{T,4,0}, i1::Int, i2::Int, i3::Int, i4::Int) = 1 + xoffset0(strides(a), i1, i2, i3, i4)
uindex{T}(a::NonContViews{T,4}, i1::Int, i2::Int, i3::Int, i4::Int) = 1 + xoffset(strides(a), i1, i2, i3, i4)

uindex{T}(a::NonContViews{T,4}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = uindex(a, i1, i2, i3, i4)

# 5D

uindex{T}(a::NonContViews{T,5}, i1::Int) =
    ((j1, j2, j3, j4, j5) = ind2sub(size(a), i1); uindex(a, j1, j2, j3, j4, j5))
uindex{T}(a::NonContViews{T,5}, i1::Int, i2::Int) =
    ((j2, j3, j4, j5) = ind2sub(size(a)[2:5], i2); uindex(a, i1, j2, j3, j4, j5))
uindex{T}(a::NonContViews{T,5}, i1::Int, i2::Int, i3::Int) =
    ((j3, j4, j5) = ind2sub(size(a)[3:5], i3); uindex(a, i1, i2, j3, j4, j5))
uindex{T}(a::NonContViews{T,5}, i1::Int, i2::Int, i3::Int, i4::Int) =
    ((j4, j5) = ind2sub(size(a)[4:5], i4); uindex(a, i1, i2, i3, j4, j5))

uindex{T}(a::NonContViews{T,5,0}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    1 + xoffset0(strides(a), i1, i2, i3, i4, i5)
uindex{T}(a::NonContViews{T,5}, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    1 + xoffset(strides(a), i1, i2, i3, i4, i5)



### getindex

getindex(a::ArrayView) = uget(a, 1)

getindex(a::ContViews, i::Int) = uget(a, i)
getindex(a::ContViews, i1::Int, i2::Int) = uget(a, sub2ind(size(a), i1, i2))
getindex(a::ContViews, i1::Int, i2::Int, i3::Int) = uget(a, sub2ind(size(a), i1, i2, i3))
getindex(a::ContViews, i1::Int, i2::Int, i3::Int, i4::Int) = uget(a, sub2ind(size(a), i1, i2, i3, i4))
getindex(a::ContViews, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = uget(a, sub2ind(size(a), i1, i2, i3, i4, i5))

getindex(a::NonContViews, i::Int) = uget(a, uindex(a, i))
getindex(a::NonContViews, i1::Int, i2::Int) = uget(a, uindex(a, i1, i2))
getindex(a::NonContViews, i1::Int, i2::Int, i3::Int) = uget(a, uindex(a, i1, i2, i3))
getindex(a::NonContViews, i1::Int, i2::Int, i3::Int, i4::Int) = uget(a, uindex(a, i1, i2, i3, i4))
getindex(a::NonContViews, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = uget(a, uindex(a, i1, i2, i3, i4, i5))

getindex(a::StridedArrayView, i::Integer) = getindex(a, idx(i))
getindex(a::StridedArrayView, i1::Integer, i2::Integer) = getindex(a, idx(i1), idx(i2))
getindex(a::StridedArrayView, i1::Integer, i2::Integer, i3::Integer) = getindex(a, idx(i1), idx(i2), idx(i3))
getindex(a::StridedArrayView, i1::Integer, i2::Integer, i3::Integer, i4::Integer) = getindex(a, idx(i1), idx(i2), idx(i3), idx(i4))
getindex(a::StridedArrayView, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer) = getindex(a, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5))


### setindex!

setindex!{T}(a::ContViews{T}, v, i::Int) = uset!(a, convert(T, v), i)
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int) = uset!(a, convert(T, v), sub2ind(size(a), i1, i2))
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int, i3::Int) = uset!(a, convert(T, v), sub2ind(size(a), i1, i2, i3))
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int) = uset!(a, convert(T, v), sub2ind(size(a), i1, i2, i3, i4))
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = uset!(a, convert(T, v), sub2ind(size(a), i1, i2, i3, i4, i5))

setindex!{T}(a::NonContViews{T}, v, i::Int) = uset!(a, convert(T, v), uindex(a, i))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int) = uset!(a, convert(T, v), uindex(a, i1, i2))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int, i3::Int) = uset!(a, convert(T, v), uindex(a, i1, i2, i3))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int) = uset!(a, convert(T, v), uindex(a, i1, i2, i3, i4))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) = uset!(a, convert(T, v), uindex(a, i1, i2, i3, i4, i5))

setindex!(a::StridedArrayView, v, i::Integer) = setindex!(a, v, idx(i))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer) = setindex!(a, v, idx(i1), idx(i2))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer, i3::Integer) = setindex!(a, v, idx(i1), idx(i2), idx(i3))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer, i3::Integer, i4::Integer) = setindex!(a, v, idx(i1), idx(i2), idx(i3), idx(i4))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer) = setindex!(a, v, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5))
