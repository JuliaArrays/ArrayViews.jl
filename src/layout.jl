# layout-related functions

typealias ContViews{T,N} Union(ContiguousView{T,N},UnsafeContiguousView{T,N})
typealias NonContViews{T,N,M} Union(StridedView{T,N,M}, UnsafeStridedView{T,N,M})

typealias ContiguousArray{T,N} Union(Array{T,N}, ContiguousView{T,N})
typealias ContiguousVector{T} ContiguousArray{T,1}
typealias ContiguousMatrix{T} ContiguousArray{T,2}

if VERSION >= v"0.4.0-dev+1784"
    import Base: linearindexing, LinearFast, LinearSlow

    linearindexing(a::ContViews) = LinearFast()
    linearindexing(a::NonContViews) = LinearSlow()
    linearindexing{T}(a::NonContViews{T,1}) = LinearFast()
end

## strides method

strides{T}(a::ContViews{T,1}) = (1,)
strides{T}(a::ContViews{T,2}) = (1, a.shp[1])
strides{T}(a::ContViews{T,3}) = ((d1, d2, d3) = size(a); (1, d1, d1 * d2))

strides{T}(a::ContViews{T,4}) = ((d1, d2, d3, d4) = size(a); (1, d1, d1 * d2, d1 * d2 * d3))

function strides{T}(a::ContViews{T,5})
    (d1, d2, d3, d4, d5) = a.shp
    s3 = d1 * d2
    s4 = s3 * d3
    s5 = s4 * d4
    (1, d1, s3, s4, s5)
end

strides(a::NonContViews) = a.strides


## stride method

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

 stride{T}(a::ContiguousView{T,4}, d::Integer) =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] :
     d == 3 ? a.shp[1] * a.shp[2] :
     d == 4 ? a.shp[1] * a.shp[2] * a.shp[3] : length(a))::Int

stride{T}(a::ContiguousView{T,5}, d::Integer) =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] :
     d == 3 ? a.shp[1] * a.shp[2] :
     d == 4 ? a.shp[1] * a.shp[2] * a.shp[3] :
     d == 5 ? a.shp[1] * a.shp[2] * a.shp[3] * a.shp[4] : length(a))::Int

stride{T,N}(a::NonContViews{T,N}, d::Integer) =
    (d > 0 || error("dimension out of range.");
     d <= N ? a.strides[d] : a.strides[N])


 # test contiguousness

iscontiguous(a::ContViews) = true

iscontiguous{T,N}(a::NonContViews{T,N}) = _iscontiguous(size(a), strides(a))

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
