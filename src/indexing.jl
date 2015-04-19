### Common indexing functions

# Note: each subtype of ArrayView should implement uindex methods,
# which getindex and setindex! rely on to locate the element position

idx(i::Integer) = convert(Int, i)::Int
idx(i::Int) = i


# getindex

getindex(a::ArrayView) = getindex(a.arr, a.offset + 1)

getindex(a::ArrayView, i::Int) = getindex(a.arr, uindex(a, i))
getindex(a::ArrayView, i1::Int, i2::Int) = getindex(a.arr, uindex(a, i1, i2))
getindex(a::ArrayView, i1::Int, i2::Int, i3::Int) =
    getindex(a.arr, uindex(a, i1, i2, i3))
getindex(a::ArrayView, i1::Int, i2::Int, i3::Int, i4::Int) =
    getindex(a.arr, uindex(a, i1, i2, i3, i4))
getindex(a::ArrayView, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    getindex(a.arr, uindex(a, i1, i2, i3, i4, i5))
getindex(a::ArrayView, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, i6::Int) =
    getindex(a.arr, uindex(a, i1, i2, i3, i4, i5, i6))

getindex(a::ArrayView, i::Integer) = getindex(a, idx(i))
getindex(a::ArrayView, i1::Integer, i2::Integer) = getindex(a, idx(i1), idx(i2))
getindex(a::ArrayView, i1::Integer, i2::Integer, i3::Integer) =
    getindex(a, idx(i1), idx(i2), idx(i3))
getindex(a::ArrayView, i1::Integer, i2::Integer, i3::Integer, i4::Integer) =
    getindex(a, idx(i1), idx(i2), idx(i3), idx(i4))
getindex(a::ArrayView, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer) =
    getindex(a, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5))
getindex(a::ArrayView, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer, i6::Integer) =
    getindex(a, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5), idx(i6))

# setindex!

setindex!{T}(a::ArrayView{T}, v, i::Int) = setindex!(a.arr, convert(T, v), uindex(a, i))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int, i3::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2, i3))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int, i3::Int, i4::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2, i3, i4))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2, i3, i4, i5))
setindex!{T}(a::ArrayView{T}, v, i1::Int, i2::Int, i3::Int, i4::Int, i5::Int, i6::Int) =
    setindex!(a.arr, convert(T, v), uindex(a, i1, i2, i3, i4, i5, i6))

setindex!(a::ArrayView, v, i::Integer) = setindex!(a, v, idx(i))
setindex!(a::ArrayView, v, i1::Integer, i2::Integer) = setindex!(a, v, idx(i1), idx(i2))
setindex!(a::ArrayView, v, i1::Integer, i2::Integer, i3::Integer) =
    setindex!(a, v, idx(i1), idx(i2), idx(i3))
setindex!(a::ArrayView, v, i1::Integer, i2::Integer, i3::Integer, i4::Integer) =
    setindex!(a, v, idx(i1), idx(i2), idx(i3), idx(i4))
setindex!(a::ArrayView, v, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer) =
    setindex!(a, v, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5))
setindex!(a::ArrayView, v, i1::Integer, i2::Integer, i3::Integer, i4::Integer, i5::Integer, i6::Integer) =
    setindex!(a, v, idx(i1), idx(i2), idx(i3), idx(i4), idx(i5), idx(i6))
