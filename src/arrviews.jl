### View types

# use ContiguousView when contiguousness can be determined statically
immutable ContiguousView{T,N,Arr<:Array} <: ArrayView{T,N,N}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
end

ContiguousView{T,N}(arr::Array{T}, offset::Int, shp::NTuple{N,Int}) =
    ContiguousView{T,N,typeof(arr)}(arr, offset, prod(shp), shp)

ContiguousView(arr::Array, shp::Dims) = ContiguousView(arr, 0, shp)


immutable UnsafeContiguousView{T,N} <: UnsafeArrayView{T,N,N}
    ptr::Ptr{T}
    len::Int
    shp::NTuple{N,Int}
end

UnsafeContiguousView{T,N}(ptr::Ptr{T}, shp::NTuple{N,Int}) =
    UnsafeContiguousView{T,N}(ptr, prod(shp), shp)

UnsafeContiguousView{T,N}(ptr::Ptr{T}, offset::Int, shp::NTuple{N,Int}) =
    UnsafeContiguousView(ptr+offset*sizeof(T), shp)

UnsafeContiguousView(arr::Array, shp::Dims) = UnsafeContiguousView(pointer(arr), shp)

UnsafeContiguousView{T,N}(arr::Array{T}, offset::Int, shp::NTuple{N,Int}) =
    UnsafeContiguousView(pointer(arr, offset+1), shp)



# use StridedView when contiguousness can not be determined statically
# condition: M < N
immutable StridedView{T,N,M,Arr<:Array} <: ArrayView{T,N,M}
    arr::Arr
    offset::Int
    len::Int
    shp::NTuple{N,Int}
    strides::NTuple{N,Int}
end

function StridedView{T,N,M}(arr::Array{T}, offset::Int, shp::NTuple{N,Int},
                             ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M < N
    StridedView{T,N,M,typeof(arr)}(arr, offset, prod(shp), shp, strides)
end

function StridedView{T,N,M}(arr::Array{T}, shp::NTuple{N,Int},
                             ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M < N
    StridedView{T,N,M,typeof(arr)}(arr, 0, prod(shp), shp, strides)
end

immutable UnsafeStridedView{T,N,M} <: UnsafeArrayView{T,N,M}
    ptr::Ptr{T}
    len::Int
    shp::NTuple{N,Int}
    strides::NTuple{N,Int}
end

function UnsafeStridedView{T,N,M}(ptr::Ptr{T}, shp::NTuple{N,Int},
                                  ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M < N
    UnsafeStridedView{T,N,M}(ptr, prod(shp), shp, strides)
end

function UnsafeStridedView{T,N,M}(ptr::Ptr{T}, offset::Int, shp::NTuple{N,Int},
                                  ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M < N
    UnsafeStridedView(ptr+offset*sizeof(T), shp, ContRank{M}, strides)
end

function UnsafeStridedView{T,N,M}(arr::Array{T}, offset::Int, shp::NTuple{N,Int},
                                  ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M < N
    UnsafeStridedView(pointer(arr, offset+1), shp, ContRank{M}, strides)
end

function UnsafeStridedView{T,N,M}(arr::Array{T}, shp::NTuple{N,Int},
                                  ::Type{ContRank{M}}, strides::NTuple{N,Int})
    @assert M < N
    UnsafeStridedView(pointer(arr), shp, ContRank{M}, strides)
end



### basic methods

parent(a::ArrayView) = a.arr
parent(a::UnsafeArrayView) = error("Getting parent of an unsafe view is not allowed.")
parent_or_ptr(a) = parent(a)
parent_or_ptr(a::UnsafeArrayView) = a.ptr

uget(a::ArrayView, i::Int) = getindex(a.arr, a.offset + i)
uset!{T}(a::ArrayView{T}, v::T, i::Int) = setindex!(a.arr, v, a.offset + i)

uget(a::UnsafeArrayView, i::Int) = unsafe_load(a.ptr, i)
uset!{T}(a::UnsafeArrayView{T}, v::T, i::Int) = unsafe_store!(a.ptr, v, i)

offset(a::ArrayView) = a.offset
pointer(a::ArrayView) = pointer(parent(a), a.offset+1)
pointer(a::UnsafeArrayView) = a.ptr
