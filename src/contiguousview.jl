#### Contiguous views

immutable ContiguousView{T,N,Arr<:Array{T}} <: ArrayView{T,N,N}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
end

ContiguousView{T,N}(arr::Array{T}, offset::Int, shp::NTuple{N,Int}) = 
    ContiguousView{T,N,typeof(arr)}(arr, offset, *(shp...), shp)

# length & size

length(a::ContiguousView) = a.len
size(a::ContiguousView) = a.shp

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
                                                   d == 2 ? a.shp[1] :
                                                   d <= N ? *(a.shp[1:d-1]...) : length(a))
