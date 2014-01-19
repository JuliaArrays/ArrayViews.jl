# Strided Views

immutable StridedView{T,N,M,Arr<:Array{T}} <: ArrayView{T,N,M}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
    strides::NTuple{N,Int}
end

# construction

strided_view{T,N,M}(arr::Array{T}, offset::Int, shp::NTuple{N,Int}, ::Type{ContRank{M}}, strides::NTuple{N,Int}) = 
	StridedView{T,N,M,typeof(arr)}(arr, offset, *(shp...), shp, strides)

strided_view{T,N,M}(arr::Array{T}, shp::NTuple{N,Int}, ::Type{ContRank{M}}, strides::NTuple{N,Int}) = 
	StridedView{T,N,M,typeof(arr)}(arr, 0, *(shp...), shp, strides)

# length & size

length(a::StridedView) = a.len
size(a::StridedView) = a.shp

# contiguousness

iscontiguous{T,N}(a::StridedView{T,N,N}) = true;
iscontiguous{T,N}(a::StridedView{T,N}) = (stride(a, N) == *(a.shp[1:N-1]...))

# strides & stride

strides(a::StridedView) = a.strides

stride{T,N}(a::StridedView{T,N}, d::Integer) = (1 <= d <= N || error("dimension out of range."); 
                                                a.strides[d])

### index calculation

uindex{T}(a::StridedView{T,1,0}, i::Int) = a.offset + i*a.strides[1]
uindex{T}(a::StridedView{T,2,0}, i0::Int, i1::Int) = a.offset + 1 + (i0-1)*a.strides[1] + (i1-1)*a.strides[2]
uindex{T}(a::StridedView{T,2,1}, i0::Int, i1::Int) = a.offset + i0 + (i1-1)*a.strides[2]

uindex{T}(a::StridedView{T,3,0}, i0::Int, i1::Int, i2::Int) = 
	a.offset + 1 + (i0-1)*a.strides[1] + (i1-1)*a.strides[2] + (i2-1)*a.strides[3]

uindex{T}(a::StridedView{T,3}, i0::Int, i1::Int, i2::Int) = 
	a.offset + i0 + (i1-1)*a.strides[2] + (i2-1)*a.strides[3]

