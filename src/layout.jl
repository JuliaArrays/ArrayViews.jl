# layout-related functions

ContViews{T,N} =  Union{ContiguousView{T,N},UnsafeContiguousView{T,N}}
NonContViews{T,N,M} =  Union{StridedView{T,N,M}, UnsafeStridedView{T,N,M}}

ContiguousArray{T,N} =  Union{Array{T,N}, ContiguousView{T,N}}
ContiguousVector{T} =  ContiguousArray{T,1}
ContiguousMatrix{T} =  ContiguousArray{T,2}

import Base: IndexStyle, IndexLinear, IndexCartesian
IndexStyle(a::ContViews) = IndexLinear()
IndexStyle(a::NonContViews) = IndexCartesian()
IndexStyle(a::NonContViews{T,1}) where {T} = IndexLinear()

## strides method

strides(a::ContViews{T,1}) where {T} = (1,)
strides(a::ContViews{T,2}) where {T} = (1, a.shp[1])
strides(a::ContViews{T,3}) where {T} = ((d1, d2, d3) = size(a); (1, d1, d1 * d2))

strides(a::ContViews{T,4}) where {T} = ((d1, d2, d3, d4) = size(a); (1, d1, d1 * d2, d1 * d2 * d3))

function strides(a::ContViews{T,5}) where T
    (d1, d2, d3, d4, d5) = a.shp
    s3 = d1 * d2
    s4 = s3 * d3
    s5 = s4 * d4
    (1, d1, s3, s4, s5)
end

strides(a::NonContViews) = a.strides


## stride method

stride(a::ContiguousView{T,1}, d::Integer) where {T} =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 : length(a))::Int

stride(a::ContiguousView{T,2}, d::Integer) where {T} =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] : length(a))::Int

stride(a::ContiguousView{T,3}, d::Integer) where {T} =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] :
     d == 3 ? a.shp[1] * a.shp[2] : length(a))::Int

 stride(a::ContiguousView{T,4}, d::Integer) where {T} =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] :
     d == 3 ? a.shp[1] * a.shp[2] :
     d == 4 ? a.shp[1] * a.shp[2] * a.shp[3] : length(a))::Int

stride(a::ContiguousView{T,5}, d::Integer) where {T} =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] :
     d == 3 ? a.shp[1] * a.shp[2] :
     d == 4 ? a.shp[1] * a.shp[2] * a.shp[3] :
     d == 5 ? a.shp[1] * a.shp[2] * a.shp[3] * a.shp[4] : length(a))::Int

stride(a::NonContViews{T,N}, d::Integer) where {T,N} =
    (d > 0 || error("dimension out of range.");
     d <= N ? a.strides[d] : a.strides[N])


 # test contiguousness

iscontiguous(a::ContViews) = true

iscontiguous(a::NonContViews{T,N}) where {T,N} = _iscontiguous(size(a), strides(a))

_iscontiguous(shp::NTuple{0,Int}, strides::NTuple{0,Int}) = true
_iscontiguous(shp::NTuple{1,Int}, strides::NTuple{1,Int}) = (strides[1] == 1)
_iscontiguous(shp::NTuple{2,Int}, strides::NTuple{2,Int}) = (strides[1] == 1 && strides[2] == shp[1])
_iscontiguous(shp::NTuple{3,Int}, strides::NTuple{3,Int}) =
    (strides[1] == 1 &&
     strides[2] == shp[1] &&
     strides[3] == shp[1] * shp[2])

function _iscontiguous(shp::NTuple{4,Int}, strides::NTuple{4,Int})
    s2 = shp[1]
    s3 = s2 * shp[2]
    s4 = s3 * shp[3]
    strides[1] == 1 && strides[2] == s2 && strides[3] == s3 && strides[4] == s4
end

function _iscontiguous(shp::NTuple{5,Int}, strides::NTuple{5,Int})
    s2 = shp[1]
    s3 = s2 * shp[2]
    s4 = s3 * shp[3]
    s5 = s4 * shp[4]
    strides[1] == 1 && strides[2] == s2 && strides[3] == s3 && strides[4] == s4 && strides[5] == s5
end
