# Strided Views

# condition: M <= N
immutable StridedView{T,N,M,Arr<:Array{T}} <: ArrayView{T,N,M}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
    strides::NTuple{N,Int}
end

# construction

function strided_view{T,N,M}(arr::Array{T}, offset::Int, shp::NTuple{N,Int}, ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M <= N
	StridedView{T,N,M,typeof(arr)}(arr, offset, *(shp...), shp, strides)
end

function strided_view{T,N,M}(arr::Array{T}, shp::NTuple{N,Int}, ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M <= N
	StridedView{T,N,M,typeof(arr)}(arr, 0, *(shp...), shp, strides)
end

parent(a::StridedView) = a.arr

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

# 0D view

uindex{T}(a::StridedView{T,0}, i::Int) = 1

# 1D view

uindex{T}(a::StridedView{T,1,0}, i::Int) = a.offset + 1 + (i-1)*a.strides[1]
uindex{T}(a::StridedView{T,1,1}, i::Int) = a.offset + i
uindex{T}(a::StridedView{T,1}, i1::Int, i2::Int) = (i2 == 1 || throw(BoundsError()); uindex(a, i1))
uindex{T}(a::StridedView{T,1}, i1::Int, i2::Int, i3::Int) = ((i2 == i3 == 1) || throw(BoundsError()); uindex(a, i1))

# 2D view

uindex{T}(a::StridedView{T,2}, i::Int) = ((i1, i2) = ind2sub(a.shp, i); uindex(a, i1, i2))

uindex{T}(a::StridedView{T,2,0}, i1::Int, i2::Int) = a.offset + 1 + (i1-1)*a.strides[1] + (i2-1)*a.strides[2]
uindex{T}(a::StridedView{T,2,1}, i1::Int, i2::Int) = a.offset + i1 + (i2-1)*a.strides[2]
uindex{T}(a::StridedView{T,2,2}, i1::Int, i2::Int) = a.offset + i1 + (i2-1)*a.strides[2]

uindex{T}(a::StridedView{T,2}, i1::Int, i2::Int, i3::Int) = (i3 == 1 || throw(BoundsError()); uindex(a, i1, i2))

# 3D view

uindex{T}(a::StridedView{T,3}, i::Int) = ((i1, i2, i3) = ind2sub(a.shp, i); uindex(a, i1, i2, i3))

uindex{T}(a::StridedView{T,3}, i1::Int, i2::Int) = 
    ((i2_, i3_) = ind2sub((a.shp[2], a.shp[3]), i2); uindex(a, i1, i2_, i3_))

uindex{T}(a::StridedView{T,3}, i1::Int, i2::Int, i3::Int) = 
    a.offset + i1 + (i2-1)*a.strides[2] + (i3-1)*a.strides[3]

uindex{T}(a::StridedView{T,3,0}, i1::Int, i2::Int, i3::Int) = 
	a.offset + 1 + (i1-1)*a.strides[1] + (i2-1)*a.strides[2] + (i3-1)*a.strides[3]


# general (probably slow) fallback

uindex(a::StridedView, i::Int) = uindex(a, ind2sub(a.shp, i)...)
uindex{T,N}(a::StridedView{T,N}, i1::Int, i2::Int) = uindex(a, i1, ind2sub(a.shp[2:N], i2)...)

uindex{T,N}(a::StridedView{T,N}, i1::Int, i2::Int, i3::Int) = 
    uindex(a, i1, i2, ind2sub(a.shp[3:N], i3)...)

uindex{T}(a::StridedView{T}, i1::Int, i2::Int, i3::Int, i4::Int, I::Int...) = 
    _uindex(a, tuple(i1, i2, i3, i4, I...))::Int

function _uindex{T,N,L}(a::StridedView{T,N}, subs::NTuple{L,Int})
    if L == N
        s = a.offset + 1
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

