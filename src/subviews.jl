# subviews of a dense array

typealias Indexer Union(Real,Range1,Range)

#### compute view offset

_offset(i::Colon) = 0
_offset(i::Int) = i - 1
_offset(i::Real) = to_index(i) - 1
_offset(i::Ranges) = to_index(first(i)) - 1

voffset(a::Array, i::Colon) = 0
voffset(a::Array, i::Indexer) = _offset(i)

voffset(a::Array, i1::Colon, i2::Colon) = 0
voffset(a::Array, i1::Colon, i2::Indexer) = size(a,1) * _offset(i2)
voffset(a::Array, i1::Indexer, i2::Colon) = _offset(i1)
voffset(a::Array, i1::Indexer, i2::Indexer) = _offset(i1) + size(a,1) * _offset(i2)

#### compute view shape

# 1D view

vshape(a::DenseArray, i::Colon) = (length(a),)
vshape(a::DenseArray, i::Ranges) = (length(i),)

# 2D view

_succlen2{T}(a::DenseArray{T,1}) = 1
_succlen2{T}(a::DenseArray{T,2}) = size(a, 2)
_succlen2{T}(a::DenseArray{T,3}) = size(a, 2) * size(a, 3)
_succlen2(a::DenseArray) = prod(size(a)[2:end])::Int

vshape(a::DenseArray, i1::Colon, i2::Real) = (size(a,1),)
vshape(a::DenseArray, i1::Ranges, i2::Real) = (length(i1),)

vshape(a::DenseArray, i1::Real, i2::Colon) = (1, _succlen2(a))
vshape(a::DenseArray, i1::Colon, i2::Colon) = (size(a,1), _succlen2(a))
vshape(a::DenseArray, i1::Ranges, i2::Colon) = (length(i1), _succlen2(a))

vshape(a::DenseArray, i1::Real, i2::Ranges) = (1, length(i2))
vshape(a::DenseArray, i1::Colon, i2::Ranges) = (size(a,1), length(i2))
vshape(a::DenseArray, i1::Ranges, i2::Ranges) = (length(i1), length(i2))

#### compute view strides (for necessary cases)

# 1D
vstrides(a::Array, i::Ranges) = (step(i),)

# 2D

vstrides(a::Array, i1::Ranges, i2::Real) = (step(i1),)

vstrides(a::Array, i1::Union(Real,Colon,Range1), i2::Union(Colon,Range1)) = (1, size(a,1))
vstrides(a::Array, i1::Range, i2::Union(Colon,Range1)) = (step(i1), size(a,1))

vstrides(a::Array, i1::Union(Real,Colon,Range1), i2::Range) = (1, size(a,1) * step(i2))
vstrides(a::Array, i1::Range, i2::Range) = (step(i1), size(a,1) * step(i2))


#### views from arrays

## 1D view

_cview(a::Array, i) = contiguous_view(a, voffset(a, i), vshape(a, i))
_sview(a::Array, cr, i) = strided_view(a, voffset(a, i), vshape(a, i), cr, vstrides(a, i))

view(a::Array, i::Union(Colon,Range1)) = _cview(a, i)
view(a::Array, i::Range) = _sview(a, ContRank{0}, i)

## 2D view

_cview(a::Array, i1, i2) = contiguous_view(a, voffset(a, i1, i2), vshape(a, i1, i2))
_sview(a::Array, cr, i1, i2) = strided_view(a, voffset(a, i1, i2), vshape(a, i1, i2), cr, vstrides(a, i1, i2))

view(a::Array, i1::Real, i2::Union(Colon,Range1,Range)) = _sview(a, ContRank{1}, i1, i2)

view(a::Array, i1::Colon, i2::Union(Real,Colon,Range1)) = _cview(a, i1, i2)
view(a::Array, i1::Colon, i2::Range) = _sview(a, ContRank{1}, i1, i2)

view(a::Array, i1::Range1, i2::Real) = _cview(a, i1, i2)
view(a::Array, i1::Range1, i2::Union(Colon,Range1,Range)) = _sview(a, ContRank{1}, i1, i2)

view(a::Array, i1::Range, i2::Union(Real,Colon,Range1,Range)) = _sview(a, ContRank{0}, i1, i2)


