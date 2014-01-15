# Strided Views

immutable StridedView{T,N,M,Arr<:Array{T}} <: ArrayView{T,M,N}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
    strides::NTuple{N,Int}
end

StridedView{T,N}(arr::Array{T}, offset::Int, shp::NTuple{N,Int}, strides::NTuple{N,Int}) = 
    StridedView{T,N,typeof(arr)}(arr, offset, *(shp...), shp, strides)

# length & size

length(a::StridedView) = a.len
size(a::StridedView) = a.shp

# contiguousness

iscontiguous{T,N}(a::StridedView{T,N,N}) = true;
iscontiguous{T,N}(a::StridedView{T,N}) = (stride(a, N) == *(a.shp[1:N-1]...))

# strides & stride

strides(a::StridedView) = a.strides

stride{T,N}(a::StridedView{T,N}, d::Integer) = (d > 0 || error("dimension out of range."); 
                                                d <= N ? a.strides[d] : length(a))


### index calculation

uindex(a::StridedView{T,1,0}, i::Int) = a.offset + i * a.strides[1]
uindex(a::StridedView{T,2,0}, i0::Int, i1::Int) = a.offset + i0*a.strides[1] + i1*strides[2]
uindex(a::StridedView{T,2,1}, i0::Int, i1::Int) = a.offset + i0 + i1*strides[2]



