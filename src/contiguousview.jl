#### Contiguous views

immutable ContiguousView{T,N,Arr<:Array{T}} <: ArrayView{T,N,N}
    arr::Arr
    len::Int
    shp::NTuple{N,Int}
end

function ContiguousView{T,N}(arr::Array{T}, shp::NTuple{N,Int}) 
    len::Int = *(shp...)
    len == length(arr) || throw(DimensionMismatch("Inconsistent array size."))
    ContiguousView{T,N,typeof(arr)}(arr, len, shp)
end

# length

length(a::ContiguousView) = a.len

# size

size(a::ContiguousView) = a.shp
size(a::ContiguousView, d::Integer) = getdim(a.shp, d)

# contiguousness

iscontiguous(a::ContiguousView) = true;

# strides

strides{T}(a::ContiguousView{T,1}) = (1,)
strides{T}(a::ContiguousView{T,2}) = (1, a.shp[1])
strides{T}(a::ContiguousView{T,3}) = (1, a.shp[1], a.shp[1] * a.shp[2])
strides{T}(a::ContiguousView{T,4}) = (1, a.shp[1], a.shp[1] * a.shp[2], a.shp[1] * a.shp[2] * a.shp[3])

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

# stride

stride{T}(a::ContiguousView{T,1}, d::Integer) = (d > 0 || error("dimension out of range."); 
                                                 d == 1 ? 1 : length(a))

stride{T}(a::ContiguousView{T,2}, d::Integer) = (d > 0 || error("dimension out of range."); 
                                                 d == 1 ? 1 : 
                                                 d == 2 ? a.shp[1] : length(a))

stride{T,N}(a::ContiguousView{T,N}, d::Integer) = (d > 0 || error("dimension out of range."); 
                                                   d == 1 ? 1 : 
                                                   d == 2 ? a.shp[1]
                                                   d <= N ? *(a.shp[1:d-1]...) : length(a))

# getindex (for scalar)

getindex(a::ContiguousView{T}, i::Int) = arrayref(a.arr, i)
getindex(a::ContiguousView{T}, i0::Int, i1::Int) = arrayref(a.arr, sub2ind(a.shp, i0, i1))
getindex(a::ContiguousView{T}, i0::Int, i1::Int, i2::Int) = arrayref(a.arr, sub2ind(a.shp, i0, i1, i2))
getindex(a::ContiguousView{T}, i0::Int, i1::Int, i2::Int, i3::Int) = arrayref(a.arr, sub2ind(a.shp, i0, i1, i2, i3))
getindex(a::ContiguousView{T}, i0::Int, i1::Int, i2::Int, i3::Int, i4::Int, I::Int...) = 
    arrayref(a.arr, sub2ind(a.shp, i0, i1, i2, i3, i4, I...))

