# functions for convenience of use

## diagonal aview

function diagview(a::DenseArray{T,2}) where T
    m, n = size(a)
    s1, s2 = astrides(a)
    len = min(m, n)
    StridedView(parent(a), offset(a), (len,), ContRank{0}, (s1 + s2,))
end

## row vector aview

function rowvec_view(a::DenseArray{T,2}, i::Integer) where T
    m, n = size(a)
    s1, s2 = astrides(a)
    StridedView(parent(a), offset(a) + (i-1) * s1, (n,), ContRank{0}, (s2,))
end

## flatten_view

flatten_view(a::ContiguousArray) =
    ContiguousView(parent(a), offset(a), (length(a),))


## reshape_view

function reshape_view(a::ContiguousArray, shp::NTuple{N,Int}) where N
    prod(shp) == length(a) || throw(DimensionMismatch("Inconsistent array size."))
    ContiguousView(parent(a), offset(a), shp)
end

## ellipview

ellipview(a::DenseArray{T,2}, i::Union{Integer, UnitRange}) where {T} = aview(a, :, i)
ellipview(a::DenseArray{T,3}, i::Union{Integer, UnitRange}) where {T} = aview(a, :, :, i)
ellipview(a::DenseArray{T,4}, i::Union{Integer, UnitRange}) where {T} = aview(a, :, :, :, i)
ellipview(a::DenseArray{T,5}, i::Union{Integer, UnitRange}) where {T} = aview(a, :, :, :, :, i)
ellipview(a::DenseArray{T,N}, i::Union{Integer, UnitRange}) where {T,N} = aview(a, ntuple(i->Colon(),N-1)..., i)
