# subviews of a dense array

#### auxiliary

_step(i::Real) = 1
_step(i::Colon) = 1
_step(i::Ranges) = step(i)


#### compute view offset

# generic

_offset(i::Colon) = 0
_offset(i::Int) = i - 1
_offset(i::Real) = to_index(i) - 1
_offset(i::Ranges) = to_index(first(i)) - 1

aoffset(a::Array, i::Subs) = roffset(a, i)
aoffset(a::Array, i1::Subs, i2::Subs) = roffset(a, i1, i2)
aoffset(a::Array, i1::Subs, i2::Subs, i3::Subs) = roffset(a, i1, i2, i3)
aoffset(a::Array, i1::Subs, i2::Subs, i3::Subs, i4::Subs) = roffset(a, i1, i2, i3, i4)
aoffset(a::Array, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) = roffset(a, i1, i2, i3, i4, i5, I...)

aoffset(a::ArrayView, i::Subs) = a.offset + roffset(a, i)
aoffset(a::ArrayView, i1::Subs, i2::Subs) = a.offset + roffset(a, i1, i2)
aoffset(a::ArrayView, i1::Subs, i2::Subs, i3::Subs) = a.offset + roffset(a, i1, i2, i3)
aoffset(a::ArrayView, i1::Subs, i2::Subs, i3::Subs, i4::Subs) = a.offset + roffset(a, i1, i2, i3, i4)
aoffset(a::ArrayView, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) = 
    a.offset + roffset(a, i1, i2, i3, i4, i5, I...)

# 1D view

roffset(a::ContiguousArray, i::Colon) = 0
roffset(a::ContiguousArray, i::Indexer) = _offset(i)

# 2D view

roffset(a::ContiguousArray, i1::Colon, i2::Colon) = 0
roffset(a::ContiguousArray, i1::Colon, i2::Indexer) = size(a,1) * _offset(i2)
roffset(a::ContiguousArray, i1::Indexer, i2::Colon) = _offset(i1)
roffset(a::ContiguousArray, i1::Indexer, i2::Indexer) = _offset(i1) + size(a,1) * _offset(i2)

# 3D view

roffset(a::ContiguousArray, i1::Colon, i2::Colon, i3::Colon) = 0
roffset(a::ContiguousArray, i1::Colon, i2::Colon, i3::Indexer) = size(a,1) * size(a,2) * _offset(i3)
roffset(a::ContiguousArray, i1::Colon, i2::Indexer, i3::Colon) = size(a,1) * _offset(i2)
roffset(a::ContiguousArray, i1::Colon, i2::Indexer, i3::Indexer) = size(a,1) * (_offset(i2) + size(a,2) * _offset(i3))
roffset(a::ContiguousArray, i1::Indexer, i2::Colon, i3::Colon) = _offset(i1)
roffset(a::ContiguousArray, i1::Indexer, i2::Colon, i3::Indexer) = _offset(i1) + (size(a,1) * size(a,2) * _offset(i3))
roffset(a::ContiguousArray, i1::Indexer, i2::Indexer, i3::Colon) = _offset(i1) + size(a,1) * _offset(i2)
roffset(a::ContiguousArray, i1::Indexer, i2::Indexer, i3::Indexer) = _offset(i1) + size(a,1) * (_offset(i2) + size(a,2) * _offset(i3))

# multi-dimensional 

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
	return o::Int
end


#### compute view shape

_dim(a::AbstractArray, d::Int, r::Colon) = size(a, d)
_dim(a::AbstractArray, d::Int, r::Ranges) = length(r)
_dim(a::AbstractArray, d::Int, r::Real) = 1

_dim{N}(siz::NTuple{N,Int}, d::Int, r::Colon) = d <= N ? siz[d] : 1
_dim(siz::Tuple, d::Int, r::Ranges) = length(r)
_dim(siz::Tuple, d::Int, r::Real) = 1

# 1D view

vshape(a::DenseArray, i::Real) = ()
vshape(a::DenseArray, i::Colon) = (length(a),)
vshape(a::DenseArray, i::Ranges) = (length(i),)

# 2D view

_succlen2{T}(a::DenseArray{T,1}) = 1
_succlen2{T}(a::DenseArray{T,2}) = size(a, 2)
_succlen2{T}(a::DenseArray{T,3}) = size(a, 2) * size(a, 3)
_succlen2(a::DenseArray) = prod(size(a)[2:end])::Int

vshape(a::DenseArray, i1::Real, i2::Real) = ()
vshape(a::DenseArray, i1::SubsRange, i2::Real) = (_dim(a,1,i1),)
vshape(a::DenseArray, i1::Subs, i2::Colon) = (_dim(a,1,i1), _succlen2(a))
vshape(a::DenseArray, i1::Subs, i2::Ranges) = (_dim(a,1,i1), length(i2))

# 3D view

_succlen3{T}(a::DenseArray{T,1}) = 1
_succlen3{T}(a::DenseArray{T,2}) = 1
_succlen3{T}(a::DenseArray{T,3}) = size(a, 3)
_succlen3{T}(a::DenseArray{T,4}) = size(a, 3) * size(a, 4)
_succlen3(a::DenseArray) = prod(size(a)[3:end])::Int

vshape(a::DenseArray, i1::Real, i2::Real, i3::Real) = ()
vshape(a::DenseArray, i1::SubsRange, i2::Real, i3::Real) = (_dim(a,1,i1),)
vshape(a::DenseArray, i1::Subs, i2::SubsRange, i3::Real) = (_dim(a,1,i1), _dim(a,2,i2))

vshape(a::DenseArray, i1::Subs, i2::Subs, i3::Colon) = (_dim(a,1,i1), _dim(a,2,i2), _succlen3(a))
vshape(a::DenseArray, i1::Subs, i2::Subs, i3::Ranges) = (_dim(a,1,i1), _dim(a,2,i2), length(i3))

# multi-dimensional view

vshape{T,N}(a::DenseArray{T,N}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, I::Subs...) = 
	_vshape(size(a), i1, i2, i3, i4, I...)

_vshape{N}(siz::NTuple{N,Int}, i1::Real, i2::Real...) = ()
_vshape{N}(siz::NTuple{N,Int}, i1::Subs, i2::Subs...) = tuple(_dim(siz,1,i1), _vshape(siz[2:N], i2...)...)



#### compute view strides (for necessary cases)

# 1D

vstrides(a::ContiguousArray, i::Subs) = (_step(i),)

vstrides(a::DenseArray, i::Subs) = (stride(a,1) * _step(i),)

# 2D

vstrides(a::ContiguousArray, i1::Subs, i2::Real) = (_step(i1),)
vstrides(a::ContiguousArray, i1::Subs, i2::CSubs) = (_step(i1), stride(a,2))
vstrides(a::ContiguousArray, i1::Subs, i2::Range) = (_step(i1), stride(a,2) * _step(i2))

vstrides(a::DenseArray, i1::Subs, i2::Real) = (stride(a,1) * _step(i1),)
vstrides(a::DenseArray, i1::Subs, i2::Subs) = (stride(a,1) * _step(i1), stride(a,2) * _step(i2))

# 3D

vstrides(a::ContiguousArray, i1::Subs, i2::Real, i3::Real) = (_step(i1),)
vstrides(a::ContiguousArray, i1::Subs, i2::Subs, i3::Real) = (_step(i1), stride(a,2) * _step(i2))
vstrides(a::ContiguousArray, i1::Subs, i2::Subs, i3::Subs) = (_step(i1), stride(a,2) * _step(i2), stride(a,3) * _step(i3))

vstrides(a::DenseArray, i1::Subs, i2::Real, i3::Real) = (stride(a,1) * _step(i1),)
vstrides(a::DenseArray, i1::Subs, i2::Subs, i3::Real) = (stride(a,2) * _step(i1), stride(a,2) * _step(i2))
vstrides(a::DenseArray, i1::Subs, i2::Subs, i3::Subs) = (stride(a,3) * _step(i1), stride(a,2) * _step(i2), stride(a,3) * _step(i3))

# multi-dimensional array

vstrides(a::DenseArray, i1::Subs, i2::Subs, i3::Subs, i4::Subs, I::Subs...) = 
	_vstrides(strides(a), 1, i1, i2, i3, i4, I...)

_vstrides{N}(ss::NTuple{N,Int}, k::Int, i1::Real, i2::Real) = ()
_vstrides{N}(ss::NTuple{N,Int}, k::Int, i1::Subs, i2::Real) = (ss[k] * _step(i1),)
_vstrides{N}(ss::NTuple{N,Int}, k::Int, i1::Subs, i2::Subs) = (ss[k] * _step(i1), ss[k+1] * _step(i2))

_vstrides{N}(ss::NTuple{N,Int}, k::Int, i1::Real, i2::Real, i3::Real, I::Real...) = ()
_vstrides{N}(ss::NTuple{N,Int}, k::Int, i1::Subs, i2::Subs, i3::Subs, I::Subs...) = 
	tuple(ss[k] * _step(i1), _vstrides(ss[2:N], k+1, i2, i3, I...)...)


#### views from arrays

## 1D view

_cview(a::Array, i) = contiguous_view(a, aoffset(a, i), vshape(a, i))
_sview(a::Array, cr, i) = strided_view(a, aoffset(a, i), vshape(a, i), cr, vstrides(a, i))

view(a::Array, i::CSubs) = _cview(a, i)
view(a::Array, i::Range) = _sview(a, ContRank{0}, i)

## 2D view

_cview(a::Array, i1, i2) = contiguous_view(a, aoffset(a, i1, i2), vshape(a, i1, i2))
_sview(a::Array, cr, i1, i2) = strided_view(a, aoffset(a, i1, i2), vshape(a, i1, i2), cr, vstrides(a, i1, i2))

view(a::Array, i1::Real, i2::Real) = _cview(a, i1, i2)
view(a::Array, i1::Real, i2::SubsRange) = _sview(a, ContRank{1}, i1, i2)

view(a::Array, i1::Colon, i2::CSubs) = _cview(a, i1, i2)
view(a::Array, i1::Colon, i2::Range) = _sview(a, ContRank{1}, i1, i2)

view(a::Array, i1::Range1, i2::Real) = _cview(a, i1, i2)
view(a::Array, i1::Range1, i2::SubsRange) = _sview(a, ContRank{1}, i1, i2)

view(a::Array, i1::Range, i2::Subs) = _sview(a, ContRank{0}, i1, i2)

## 3D view

_cview(a::Array, i1, i2, i3) = 
    contiguous_view(a, aoffset(a, i1, i2, i3), vshape(a, i1, i2, i3))
_sview(a::Array, cr, i1, i2, i3) = 
    strided_view(a, aoffset(a, i1, i2, i3), vshape(a, i1, i2, i3), cr, vstrides(a, i1, i2, i3))

view(a::Array, i1::Real, i2::Real, i3::Real) = _cview(a, i1, i2, i3)
view(a::Array, i1::Real, i2::Real, i3::SubsRange) = _sview(a, ContRank{2}, i1, i2, i3)
view(a::Array, i1::Real, i2::SubsRange, i3::Subs) = _sview(a, ContRank{1}, i1, i2, i3)

view(a::Array, i1::Colon, i2::Colon, i3::CSubs) = _cview(a, i1, i2, i3)
view(a::Array, i1::Colon, i2::Colon, i3::Range) = _sview(a, ContRank{2}, i1, i2, i3)
view(a::Array, i1::Colon, i2::Union(Real,Range1), i3::Real) = _cview(a, i1, i2, i3)
view(a::Array, i1::Colon, i2::Union(Real,Range1), i3::SubsRange) = _sview(a, ContRank{2}, i1, i2, i3)
view(a::Array, i1::Colon, i2::Range, i3::Subs) = _sview(a, ContRank{1}, i1, i2, i3)

view(a::Array, i1::Range1, i2::Real, i3::Real) = _cview(a, i1, i2, i3)
view(a::Array, i1::Range1, i2::Real, i3::SubsRange) = _sview(a, ContRank{2}, i1, i2, i3)
view(a::Array, i1::Range1, i2::SubsRange, i3::Subs) = _sview(a, ContRank{1}, i1, i2, i3)
view(a::Array, i1::Range, i2::Subs, i3::Subs) = _sview(a, ContRank{0}, i1, i2, i3)

