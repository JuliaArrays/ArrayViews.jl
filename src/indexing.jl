
typealias ContViews{T,N} ContiguousView{T,N}
typealias NonContViews{T,N,M} StridedView{T,N,M}


### Common indexing functions

# Note: each array view type should implement
#
#   - uget(a, i):       retrieve the i-th element w.r.t. the underlying base
#   - uset!(a, v, i):   set the value of the i-th element w.r.t. the underlying base
#

idx(i::Integer) = convert(Int, i)::Int
idx(i::Int) = i

### uindex

uindex{T}(a::StridedView{T,1,0}, i::Int) = 1 + (i-1)*a.strides[1]
uindex{T}(a::StridedView{T,1,1}, i::Int) = i
uindex{T}(a::StridedView{T,1}, i1::Int, i2::Int) =
    (i2 == 1 || throw(BoundsError()); uindex(a, i1))
uindex{T}(a::StridedView{T,1}, i1::Int, i2::Int, i3::Int) =
    ((i2 == i3 == 1) || throw(BoundsError()); uindex(a, i1))

uindex{T}(a::StridedView{T,2}, i::Int) = uindex(a, ind2sub(size(a), i)...)
uindex{T}(a::StridedView{T,2,0}, i1::Int, i2::Int) =
    1 + (i1-1)*a.strides[1] + (i2-1)*a.strides[2]
uindex{T}(a::StridedView{T,2,1}, i1::Int, i2::Int) =
    i1 + (i2-1)*a.strides[2]
uindex{T}(a::StridedView{T,2,2}, i1::Int, i2::Int) =
    i1 + (i2-1)*a.strides[2]
uindex{T}(a::StridedView{T,2}, i1::Int, i2::Int, i3::Int) =
    (i3 == 1 || throw(BoundsError()); uindex(a, i1, i2))

uindex{T}(a::StridedView{T,3}, i::Int) = uindex(a, ind2sub(size(a), i)...)
uindex{T}(a::StridedView{T,3}, i1::Int, i2::Int) =
    uindex(a, i1, ind2sub((a.shp[2], a.shp[3]), i2)...)
uindex{T}(a::StridedView{T,3}, i1::Int, i2::Int, i3::Int) =
    i1 + (i2-1)*a.strides[2] + (i3-1)*a.strides[3]
uindex{T}(a::StridedView{T,3,0}, i1::Int, i2::Int, i3::Int) =
    1 + (i1-1)*a.strides[1] + (i2-1)*a.strides[2] + (i3-1)*a.strides[3]

uindex(a::StridedView, i::Int) = uindex(a, ind2sub(size(a), i)...)
uindex{T,N}(a::StridedView{T,N}, i1::Int, i2::Int) =
    uindex(a, i1, ind2sub(a.shp[2:N], i2)...)
uindex{T,N}(a::StridedView{T,N}, i1::Int, i2::Int, i3::Int) =
    uindex(a, i1, i2, ind2sub(a.shp[3:N], i3)...)
uindex{T}(a::StridedView{T}, i1::Int, i2::Int, i3::Int, i4::Int, I::Int...) =
    _uindex(a, tuple(i1, i2, i3, i4, I...))::Int


function _uindex{T,N,L}(a::StridedView{T,N}, subs::NTuple{L,Int})
    if L == N
        s = 1
        for i = 1:N
            s += (subs[i] - 1) * a.strides[i]
        end
        return s

    elseif L < N
        return uindex(a, tuple(subs[1:L-1]..., ind2sub(a.shp[L+1:N], subs[L])...))

    else # L > N
        for i = N+1:L
            subs[i] == 1 || throw(BoundsError())
        end
        return uindex(a, subs[1:N]...)
    end
end



### getindex

getindex(a::ArrayView) = uget(a, 1)

getindex(a::ContViews, i::Int) = uget(a, i)
getindex(a::ContViews, i1::Int, i2::Int) = uget(a, sub2ind(size(a), i1, i2))
getindex(a::ContViews, i1::Int, i2::Int, i3::Int) =
    uget(a, sub2ind(size(a), i1, i2, i3))
getindex(a::ContViews, i1::Int, i2::Int, i3::Int, i4::Int) =
    uget(a, sub2ind(size(a), i1, i2, i3, i4))
getindex(a::ContViews, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    uget(a, sub2ind(size(a), i1, i2, i3, i4, i5))
getindex(a::ContViews, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, i6::Int) =
    uget(a, sub2ind(size(a), i1, i2, i3, i4, i5, i6))

getindex(a::NonContViews, i::Int) = uget(a, uindex(a, i))
getindex(a::NonContViews, i1::Int, i2::Int) = uget(a, uindex(a, i1, i2))
getindex(a::NonContViews, i1::Int, i2::Int, i3::Int) =
    uget(a, uindex(a, i1, i2, i3))
getindex(a::NonContViews, i1::Int, i2::Int, i3::Int, i4::Int) =
    uget(a, uindex(a, i1, i2, i3, i4))
getindex(a::NonContViews, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    uget(a, uindex(a, i1, i2, i3, i4, i5))
getindex(a::NonContViews, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, i6::Int) =
    uget(a, uindex(a, i1, i2, i3, i4, i5, i6))

getindex(a::StridedArrayView, i::Integer) = getindex(a, idx(i))
getindex(a::StridedArrayView, i1::Integer, i2::Integer) = getindex(a, idx(i1), idx(i2))
getindex(a::StridedArrayView, i1::Integer, i2::Integer, i3::Integer) =
    getindex(a, idx(i1), idx(i2), idx(i3))
getindex(a::StridedArrayView, i1::Integer, i2::Integer, i3::Integer, i4::Integer) =
    getindex(a, idx(i1), idx(i2), idx(i3), idx(i4))
getindex(a::StridedArrayView, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer) =
    getindex(a, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5))
getindex(a::StridedArrayView, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer, i6::Integer) =
    getindex(a, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5), idx(i6))


### setindex!

setindex!{T}(a::ContViews{T}, v, i::Int) = uset!(a, convert(T, v), i)
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int) =
    uset!(a, convert(T, v), sub2ind(size(a), i1, i2))
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int, i3::Int) =
    uset!(a, convert(T, v), sub2ind(size(a), i1, i2, i3))
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int) =
    uset!(a, convert(T, v), sub2ind(size(a), i1, i2, i3, i4))
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    uset!(a, convert(T, v), sub2ind(size(a), i1, i2, i3, i4, i5))
setindex!{T}(a::ContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, i6::Int) =
    uset!(a, convert(T, v), sub2ind(size(a), i1, i2, i3, i4, i5, i6))

setindex!{T}(a::NonContViews{T}, v, i::Int) = uset!(a, convert(T, v), uindex(a, i))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int) =
    uset!(a, convert(T, v), uindex(a, i1, i2))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int, i3::Int) =
    uset!(a, convert(T, v), uindex(a, i1, i2, i3))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int) =
    uset!(a, convert(T, v), uindex(a, i1, i2, i3, i4))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    uset!(a, convert(T, v), uindex(a, i1, i2, i3, i4, i5))
setindex!{T}(a::NonContViews{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, i6::Int) =
    uset!(a, convert(T, v), uindex(a, i1, i2, i3, i4, i5, i6))

setindex!(a::StridedArrayView, v, i::Integer) = setindex!(a, v, idx(i))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer) = setindex!(a, v, idx(i1), idx(i2))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer, i3::Integer) =
    setindex!(a, v, idx(i1), idx(i2), idx(i3))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer, i3::Integer, i4::Integer) =
    setindex!(a, v, idx(i1), idx(i2), idx(i3), idx(i4))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer) =
    setindex!(a, v, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5))
setindex!(a::StridedArrayView, v, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer, i6::Integer) =
    setindex!(a, v, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5), idx(i6))
