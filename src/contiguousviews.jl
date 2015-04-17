
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


### Methods

offset(a::Array) = 0

parent(a::ContiguousView) = a.arr
offset(a::ContiguousView) = a.offset
length(a::ContiguousView) = a.len
size(a::ContiguousView) = a.shp

iscontiguous(a::AbstractArray) = false
iscontiguous(a::Array) = true
iscontiguous(a::ContiguousView) = true

strides{T}(a::ContiguousView{T,1}) = (1,)
strides{T}(a::ContiguousView{T,2}) = (1, a.shp[1])
strides{T}(a::ContiguousView{T,3}) = (1, a.shp[1], a.shp[1] * a.shp[2])
strides{T}(a::ContiguousView{T,4}) =
    (1, a.shp[1], a.shp[1] * a.shp[2], a.shp[1] * a.shp[2] * a.shp[3])

function strides{T,N}(a::ContiguousView{T,N})
    s = Array(Int, N)
    s[1] = p = 1
    d = 1
    while d < N
        p *= a.shp[d]
        d += 1
        s[d] = p
    end
    return tuple(s...)::NTuple{N,Int}
end

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

stride{T,N}(a::ContiguousView{T,N}, d::Integer) =
    (d > 0 || error("dimension out of range.");
     d == 1 ? 1 :
     d == 2 ? a.shp[1] :
     d <= N ? *(a.shp[1:d-1]...) : length(a))::Int


### Indexing

uindex{T,N}(a::ArrayView{T,N,N}, i::Int) = a.offset + i
uindex{T,N}(a::ArrayView{T,N,N}, i1::Int, i2::Int) =
    a.offset + sub2ind(size(a), i1, i2)
uindex{T,N}(a::ArrayView{T,N,N}, i1::Int, i2::Int, i3::Int) =
    a.offset + sub2ind(size(a), i1, i2, i3)
uindex{T,N}(a::ArrayView{T,N,N}, i1::Int, i2::Int, i3::Int, i4::Int, I::Int...) =
    a.offset + sub2ind(size(a), i1, i2, i3, i4, I...)
    
