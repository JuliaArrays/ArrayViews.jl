# Note: construction of subviews involve several steps:
#
#  - compute aview offset (w.r.t. the parent)
#  - compute aview shape
#  - compute strides (for non-contiguous views only)
#  - decide contiguous rank (statically)
#  - make the aview
#

##### Compute offset #####

_offset(i::Colon) = 0
_offset(i::Int) = i - 1
_offset(i::Real) = to_index(i) - 1
_offset(i::Range) = to_index(first(i)) - 1

_step(i::Real) = 1
_step(i::Colon) = 1
_step(i::Range) = step(i)

# aoffset: offset w.r.t. the underlying array (i.e. parent)

aoffset(a::Union{Array, UnsafeArrayView}, i::Subs) = roffset(a, i)
aoffset(a::Union{Array, UnsafeArrayView}, i1::Subs, i2::Subs) = roffset(a, i1, i2)
aoffset(a::Union{Array, UnsafeArrayView}, i1::Subs, i2::Subs, i3::Subs) = roffset(a, i1, i2, i3)
aoffset(a::Union{Array, UnsafeArrayView}, i1::Subs, i2::Subs, i3::Subs, i4::Subs) =
    roffset(a, i1, i2, i3, i4)
aoffset(a::Union{Array, UnsafeArrayView}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) =
    roffset(a, i1, i2, i3, i4, i5, I...)

aoffset(a::ArrayView, i::Subs) = a.offset + roffset(a, i)
aoffset(a::ArrayView, i1::Subs, i2::Subs) = a.offset + roffset(a, i1, i2)
aoffset(a::ArrayView, i1::Subs, i2::Subs, i3::Subs) =
    a.offset + roffset(a, i1, i2, i3)
aoffset(a::ArrayView, i1::Subs, i2::Subs, i3::Subs, i4::Subs) =
    a.offset + roffset(a, i1, i2, i3, i4)
aoffset(a::ArrayView, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) =
    a.offset + roffset(a, i1, i2, i3, i4, i5, I...)

# roffset: offset w.r.t. the first element of the aview

# 1D

roffset(a::ContiguousArray, i::Colon) = 0
roffset(a::ContiguousArray, i::SubsNC) = _offset(i)

roffset(a::StridedVector, i::Colon) = 0
roffset(a::StridedVector, i::SubsNC) = _offset(i) * stride(a,1)

# 2D

roffset(a::ContiguousArray, i1::Colon, i2::Colon) = 0
roffset(a::ContiguousArray, i1::Colon, i2::SubsNC) = size(a,1) * _offset(i2)
roffset(a::ContiguousArray, i1::SubsNC, i2::Colon) = _offset(i1)
roffset(a::ContiguousArray, i1::SubsNC, i2::SubsNC) =
    _offset(i1) + size(a,1) * _offset(i2)

roffset(a::StridedMatrix, i1::Colon, i2::Colon) = 0
roffset(a::StridedMatrix, i1::Colon, i2::SubsNC) = _offset(i2) * stride(a,2)
roffset(a::StridedMatrix, i1::SubsNC, i2::Colon) = _offset(i1) * stride(a,1)
roffset(a::StridedMatrix, i1::SubsNC, i2::SubsNC) =
    _offset(i1) * stride(a,1) + _offset(i2) * stride(a,2)

# 3D

roffset(a::ContiguousArray, i1::Colon, i2::Colon, i3::Colon) = 0
roffset(a::ContiguousArray, i1::Colon, i2::Colon, i3::SubsNC) =
    size(a,1) * size(a,2) * _offset(i3)
roffset(a::ContiguousArray, i1::Colon, i2::SubsNC, i3::Colon) =
    size(a,1) * _offset(i2)
roffset(a::ContiguousArray, i1::Colon, i2::SubsNC, i3::SubsNC) =
    size(a,1) * (_offset(i2) + size(a,2) * _offset(i3))
roffset(a::ContiguousArray, i1::SubsNC, i2::Colon, i3::Colon) = _offset(i1)
roffset(a::ContiguousArray, i1::SubsNC, i2::Colon, i3::SubsNC) =
    _offset(i1) + (size(a,1) * size(a,2) * _offset(i3))
roffset(a::ContiguousArray, i1::SubsNC, i2::SubsNC, i3::Colon) =
    _offset(i1) + size(a,1) * _offset(i2)
roffset(a::ContiguousArray, i1::SubsNC, i2::SubsNC, i3::SubsNC) =
    _offset(i1) + size(a,1) * (_offset(i2) + size(a,2) * _offset(i3))

roffset(a::StridedArray{T,3}, i1::Colon, i2::Colon, i3::Colon) where {T} = 0
roffset(a::StridedArray{T,3}, i1::Colon, i2::Colon, i3::SubsNC) where {T} =
    _offset(i3) * stride(a,3)
roffset(a::StridedArray{T,3}, i1::Colon, i2::SubsNC, i3::Colon) where {T} =
    _offset(i2) * stride(a,2)
roffset(a::StridedArray{T,3}, i1::Colon, i2::SubsNC, i3::SubsNC) where {T} =
    _offset(i2) * stride(a,2) + _offset(i3) * stride(a,3)
roffset(a::StridedArray{T,3}, i1::SubsNC, i2::Colon, i3::Colon) where {T} =
    _offset(i1) * stride(a,1)
roffset(a::StridedArray{T,3}, i1::SubsNC, i2::Colon, i3::SubsNC) where {T} =
    _offset(i1) * stride(a,1) + _offset(i3) * stride(a,3)
roffset(a::StridedArray{T,3}, i1::SubsNC, i2::SubsNC, i3::Colon) where {T} =
    _offset(i1) * stride(a,1) + _offset(i2) * stride(a,2)
roffset(a::StridedArray{T,3}, i1::SubsNC, i2::SubsNC, i3::SubsNC) where {T} =
    _offset(i1) * stride(a,1) + _offset(i2) * stride(a,2) + _offset(i3) * stride(a,3)


# 4D (partial)
function roffset(a::ContiguousArray, i1::Subs, i2::Subs, i3::Subs, i4::Subs)
    o = _offset(i1)
    s = size(a,1)
    o += s * _offset(i2)
    o += (s *= size(a,2)) * _offset(i3)
    o += (s *= size(a,3)) * _offset(i4)
    return o
end

function roffset(a::ContiguousArray, i1::Colon, i2::Subs, i3::Subs, i4::Subs)
    s = size(a,1)
    o = s * _offset(i2)
    o += (s *= size(a,2)) * _offset(i3)
    o += (s *= size(a,3)) * _offset(i4)
    return o
end

function roffset(a::ContiguousArray, i1::Colon, i2::Colon, i3::Subs, i4::Subs)
    s = size(a,1)
    o = (s *= size(a,2)) * _offset(i3)
    o += (s *= size(a,3)) * _offset(i4)
    return o
end

# General

roffset(a::ContiguousArray, i1::Colon, i2::Colon, i3::Colon, i4::Colon) = 0
roffset(a::ContiguousArray, i1::Colon, i2::Colon, i3::Colon, i4::Colon, I::Colon...) = 0

function roffset(a::ContiguousArray, i1::Subs, i2::Subs, i3::Subs, i4::Subs, I::Subs...)
    o = _offset(i1)
    s = size(a,1)
    o += s * _offset(i2)
    o += (s *= size(a,2)) * _offset(i3)
    o += (s *= size(a,3)) * _offset(i4)
    for i = 1:length(I)
        o += (s *= size(a,i+3)) * _offset(I[i])
    end
    return o
end

roffset(a::StridedArray, i1::Subs, i2::Subs, i3::Subs, I::Subs...) =
    _roffset(strides(a), tuple(i1, i2, i3, I...))::Int

function _roffset(ss::NTuple{N,Int}, subs::NTuple{N}) where N
    o = _offset(subs[1]) * ss[1]
    for i = 2:N
        o += _offset(subs[i]) * ss[i]
    end
    return o
end


##### Compute aview shape #####

_dim(a::AbstractArray, d::Int, r::Colon) = size(a, d)
_dim(a::AbstractArray, d::Int, r::Range) = length(r)

_dim(siz::NTuple{N,Int}, d::Int, r::Colon) where {N} = d <= N ? siz[d] : 1
_dim(siz::Tuple, d::Int, r::Range) = length(r)

# 1D
vshape(a::DenseArray, i::Real) = ()
vshape(a::DenseArray, i::Colon) = (length(a),)
vshape(a::DenseArray, i::Range) = (length(i),)

# 2D

_succlen2(a::DenseArray{T,1}) where {T} = 1
_succlen2(a::DenseArray{T,2}) where {T} = size(a, 2)
_succlen2(a::DenseArray{T,3}) where {T} = size(a, 2) * size(a, 3)
_succlen2(a::DenseArray) = prod(size(a)[2:end])::Int

vshape(a::DenseArray, i1::Real, i2::Real) = ()
vshape(a::DenseArray, i1::SubsRange, i2::Real) = (_dim(a,1,i1),)
vshape(a::DenseArray, i1::SubsRange, i2::Colon) = (_dim(a,1,i1), _succlen2(a))
vshape(a::DenseArray, i1::SubsRange, i2::Range) = (_dim(a,1,i1), length(i2))
vshape(a::DenseArray, i1::Real, i2::Colon) = (_succlen2(a),)
vshape(a::DenseArray, i1::Real, i2::Range) = (length(i2),)

# 3D

_succlen3(a::DenseArray{T,1}) where {T} = 1
_succlen3(a::DenseArray{T,2}) where {T} = 1
_succlen3(a::DenseArray{T,3}) where {T} = size(a, 3)
_succlen3(a::DenseArray{T,4}) where {T} = size(a, 3) * size(a, 4)
_succlen3(a::DenseArray) = prod(size(a)[3:end])::Int

vshape(a::DenseArray, i1::Real, i2::Real, i3::Real) = ()
vshape(a::DenseArray, i1::SubsRange, i2::Real, i3::Real) = (_dim(a,1,i1),)
vshape(a::DenseArray, i1::SubsRange, i2::SubsRange, i3::Real) =
    (_dim(a,1,i1), _dim(a,2,i2))
vshape(a::DenseArray, i1::Real, i2::SubsRange, i3::Real) =
    (_dim(a,2,i2),)

vshape(a::DenseArray, i1::Subs, i2::Subs, i3::Colon) =
    (_dim(a,1,i1), _dim(a,2,i2), _succlen3(a))
vshape(a::DenseArray, i1::Subs, i2::Subs, i3::Range) =
    (_dim(a,1,i1), _dim(a,2,i2), length(i3))

vshape(a::DenseArray, i1::Real, i2::Subs, i3::Colon) =
    (_dim(a,2,i2), _succlen3(a))
vshape(a::DenseArray, i1::Real, i2::Subs, i3::Range) =
    (_dim(a,2,i2), length(i3))

vshape(a::DenseArray, i1::Subs, i2::Real, i3::Colon) =
    (_dim(a,1,i1), _succlen3(a))
vshape(a::DenseArray, i1::Subs, i2::Real, i3::Range) =
    (_dim(a,1,i1), length(i3))

vshape(a::DenseArray, i1::Real, i2::Real, i3::Colon) =
    (_succlen3(a),)
vshape(a::DenseArray, i1::Real, i2::Real, i3::Range) =
    (length(i3),)

# 4D

_succlen4(a::DenseArray{T,1}) where T = 1
_succlen4(a::DenseArray{T,2}) where T = 1
_succlen4(a::DenseArray{T,3}) where T = 1
_succlen4(a::DenseArray{T,4}) where T = size(a, 4)
_succlen4(a::DenseArray{T,5}) where T = size(a, 4) * size(a, 5)
_succlen4(a::DenseArray) = prod(size(a)[4:end])::Int

vshape(a::DenseArray, i1::Real, i2::Real, i3::Real, i4::Real) = ()
vshape(a::DenseArray, i1::SubsRange, i2::Real, i3::Real, i4::Real) = (_dim(a,1,i1),)
vshape(a::DenseArray, i1::SubsRange, i2::SubsRange, i3::Real, i4::Real) =
    (_dim(a,1,i1), _dim(a,2,i2))
vshape(a::DenseArray, i1::SubsRange, i2::SubsRange, i3::SubsRange, i4::Real) =
    (_dim(a,1,i1), _dim(a,2,i2), _dim(a,3,i3))

vshape(a::DenseArray, i1::SubsRange, i2::SubsRange, i3::SubsRange, i4::Colon) =
    (_dim(a,1,i1), _dim(a,2,i2), _dim(a,3,i3), _succlen4(a))
vshape(a::DenseArray, i1::SubsRange, i2::SubsRange, i3::SubsRange, i4::Range) =
    (_dim(a,1,i1), _dim(a,2,i2), _dim(a,3,i3), length(i4))


# multi-dimensional

vshape(a::DenseArray{T,N}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, I::Subs...) where {T,N} =
    _vshape(size(a), i1, i2, i3, i4, I...)

_vshape(siz::NTuple{N,Int}, i1::Real) where {N} = ()
_vshape(siz::NTuple{N,Int}, i1::Real, i2::Real...) where {N} = ()

_vshape(siz::NTuple{N,Int}, i1::Colon) where {N} = (prod(siz),)
_vshape(siz::NTuple{N,Int}, i1::Range) where {N} = (length(i1),)
_vshape(siz::NTuple{N,Int}, i1::SubsRange, i2::Subs...) where {N} = tuple(_dim(siz,1,i1), _vshape(siz[2:N], i2...)...)
_vshape(siz::NTuple{N,Int}, i1::Real, i2::Subs...) where {N} = tuple(_vshape(siz[2:N], i2...)...)

##### Compute strides #####

# 1D

vstrides(a::ContiguousArray, i::Subs) = (_step(i),)
vstrides(a::DenseArray, i::Subs) = (stride(a,1) * _step(i),)

# 2D
vstrides(a::ContiguousArray, i1::Real, i2::Real) = ()
vstrides(a::ContiguousArray, i1::SubsRange, i2::Real) = (_step(i1),)
vstrides(a::ContiguousArray, i1::SubsRange, i2::Union{Colon,UnitRange}) = (_step(i1), stride(a,2))
vstrides(a::ContiguousArray, i1::Real, i2::Union{Colon,UnitRange}) = (stride(a,2),)
vstrides(a::ContiguousArray, i1::SubsRange, i2::Range) = (_step(i1), stride(a,2) * _step(i2))
vstrides(a::ContiguousArray, i1::Real, i2::Range) = (stride(a,2) * _step(i2),)

vstrides(a::DenseArray, i1::Real, i2::Real) = ()
vstrides(a::DenseArray, i1::SubsRange, i2::Real) = (stride(a,1) * _step(i1),)
vstrides(a::DenseArray, i1::SubsRange, i2::Subs) =
    (stride(a,1) * _step(i1), stride(a,2) * _step(i2))
vstrides(a::DenseArray, i1::Real, i2::Subs) =
    (stride(a,2) * _step(i2),)

# multi-dimensional array

vstrides(a::DenseArray, i1::Subs, i2::Subs, i3::Subs, I::Subs...) =
    _vstrides(strides(a), 1, i1, i2, i3, I...)

_vstrides(ss::NTuple{N,Int}, k::Int, i1::Real, i2::Real) where {N} = ()
_vstrides(ss::NTuple{N,Int}, k::Int, i1::SubsRange, i2::Real) where {N} =
    (ss[k] * _step(i1),)
_vstrides(ss::NTuple{N,Int}, k::Int, i1::Real, i2::SubsRange) where {N} =
    (ss[k+1] * _step(i2),)
_vstrides(ss::NTuple{N,Int}, k::Int, i1::SubsRange, i2::SubsRange) where {N} =
    (ss[k] * _step(i1), ss[k+1] * _step(i2))

_vstrides(ss::NTuple{N,Int}, k::Int, i1::Real, i2::Real, i3::Real, I::Real...) where {N} = ()
_vstrides(ss::NTuple{N,Int}, k::Int, i1::SubsRange, i2::Subs, i3::Subs, I::Subs...) where {N} =
    tuple(ss[k] * _step(i1), _vstrides(ss, k+1, i2, i3, I...)...)
_vstrides(ss::NTuple{N,Int}, k::Int, i1::Real, i2::Subs, i3::Subs, I::Subs...) where {N} =
    _vstrides(ss, k+1, i2, i3, I...)


##### View construction ######

make_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i::Subs) where {N} =
    ContiguousView(parent(a), aoffset(a, i), shp)

make_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs) where {N} =
    ContiguousView(parent(a), aoffset(a, i1, i2), shp)

make_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs) where {N} =
    ContiguousView(parent(a), aoffset(a, i1, i2, i3), shp)

make_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs, i4::Subs) where {N} =
    ContiguousView(parent(a), aoffset(a, i1, i2, i3, i4), shp)

make_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) where {N} =
    ContiguousView(parent(a), aoffset(a, i1, i2, i3, i4, i5, I...), shp)

make_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i::Subs) where {M,N} =
    StridedView(parent(a), aoffset(a, i), shp, cr, vstrides(a, i))

make_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs) where {M,N} =
    StridedView(parent(a), aoffset(a, i1, i2), shp, cr, vstrides(a, i1, i2))

make_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs) where {M,N} =
    StridedView(parent(a), aoffset(a, i1, i2, i3), shp, cr, vstrides(a, i1, i2, i3))

make_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs, i4::Subs) where {M,N} =
    StridedView(parent(a), aoffset(a, i1, i2, i3, i4), shp, cr, vstrides(a, i1, i2, i3, i4))

make_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) where {M,N} =
    StridedView(parent(a), aoffset(a, i1, i2, i3, i4, i5, I...), shp, cr, vstrides(a, i1, i2, i3, i4, i5, I...))


make_unsafe_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i::Subs) where {N} =
    UnsafeContiguousView(parent_or_ptr(a), aoffset(a, i), shp)

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs) where {N} =
    UnsafeContiguousView(parent_or_ptr(a), aoffset(a, i1, i2), shp)

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs) where {N} =
    UnsafeContiguousView(parent_or_ptr(a), aoffset(a, i1, i2, i3), shp)

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs, i4::Subs) where {N} =
    UnsafeContiguousView(parent_or_ptr(a), aoffset(a, i1, i2, i3, i4), shp)

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{N}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) where {N} =
    UnsafeContiguousView(parent_or_ptr(a), aoffset(a, i1, i2, i3, i4, i5, I...), shp)

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i::Subs) where {M,N} =
    UnsafeStridedView(parent_or_ptr(a), aoffset(a, i), shp, cr, vstrides(a, i))

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs) where {M,N} =
    UnsafeStridedView(parent_or_ptr(a), aoffset(a, i1, i2), shp, cr, vstrides(a, i1, i2))

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs) where {M,N} =
    UnsafeStridedView(parent_or_ptr(a), aoffset(a, i1, i2, i3), shp, cr, vstrides(a, i1, i2, i3))

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs, i4::Subs) where {M,N} =
    UnsafeStridedView(parent_or_ptr(a), aoffset(a, i1, i2, i3, i4), shp, cr, vstrides(a, i1, i2, i3, i4))

make_unsafe_aview(a::DenseArray, cr::Type{ContRank{M}}, shp::NTuple{N,Int}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) where {M,N} =
    UnsafeStridedView(parent_or_ptr(a), aoffset(a, i1, i2, i3, i4, i5, I...), shp, cr, vstrides(a, i1, i2, i3, i4, i5, I...))


##### Interface

aview(a::Array) = ContiguousView(a, size(a))
aview(a::ArrayView) = a

aview(a::DenseArray, i::Subs) =
    (shp = vshape(a, i); make_aview(a, restrict_crank(acontrank(a, i), shp), shp, i))

aview(a::DenseArray, i1::Subs, i2::Subs) =
    (shp = vshape(a, i1, i2); make_aview(a, restrict_crank(acontrank(a, i1, i2), shp), shp, i1, i2))

aview(a::DenseArray, i1::Subs, i2::Subs, i3::Subs) =
    (shp = vshape(a, i1, i2, i3); make_aview(a, restrict_crank(acontrank(a, i1, i2, i3), shp), shp, i1, i2, i3))

aview(a::DenseArray, i1::Subs, i2::Subs, i3::Subs, i4::Subs) =
    (shp = vshape(a, i1, i2, i3, i4); make_aview(a, restrict_crank(acontrank(a, i1, i2, i3, i4), shp), shp, i1, i2, i3, i4))

aview(a::DenseArray, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) =
    (shp = vshape(a, i1, i2, i3, i4, i5, I...);
     make_aview(a, restrict_crank(acontrank(a, i1, i2, i3, i4, i5, I...), shp), shp, i1, i2, i3, i4, i5, I...))


unsafe_aview(a::Array) = ContiguousView(a, size(a))
unsafe_aview(a::ArrayView) = a

unsafe_aview(a::DenseArray, i::Subs) =
    (shp = vshape(a, i); make_unsafe_aview(a, restrict_crank(acontrank(a, i), shp), shp, i))

unsafe_aview(a::DenseArray, i1::Subs, i2::Subs) =
    (shp = vshape(a, i1, i2); make_unsafe_aview(a, restrict_crank(acontrank(a, i1, i2), shp), shp, i1, i2))

unsafe_aview(a::DenseArray, i1::Subs, i2::Subs, i3::Subs) =
    (shp = vshape(a, i1, i2, i3); make_unsafe_aview(a, restrict_crank(acontrank(a, i1, i2, i3), shp), shp, i1, i2, i3))

unsafe_aview(a::DenseArray, i1::Subs, i2::Subs, i3::Subs, i4::Subs) =
    (shp = vshape(a, i1, i2, i3, i4); make_unsafe_aview(a, restrict_crank(acontrank(a, i1, i2, i3, i4), shp), shp, i1, i2, i3, i4))

unsafe_aview(a::DenseArray, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) =
    (shp = vshape(a, i1, i2, i3, i4, i5, I...);
     make_unsafe_aview(a, restrict_crank(acontrank(a, i1, i2, i3, i4, i5, I...), shp), shp, i1, i2, i3, i4, i5, I...))
