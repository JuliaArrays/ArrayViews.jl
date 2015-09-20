# functions for convenience of use

## diagonal view

function diagview{T}(a::DenseArray{T,2})
    m, n = size(a)
    s1, s2 = strides(a)
    len = min(m, n)
    StridedView(parent(a), offset(a), (len,), ContRank{0}, (s1 + s2,))
end

## row vector view

function rowvec_view{T}(a::DenseArray{T,2}, i::Integer)
    m, n = size(a)
    s1, s2 = strides(a)
    StridedView(parent(a), offset(a) + (i-1) * s1, (n,), ContRank{0}, (s2,))
end

## flatten_view

flatten_view(a::ContiguousArray) =
    ContiguousView(parent(a), offset(a), (length(a),))


## reshape_view

function reshape_view{N}(a::ContiguousArray, shp::NTuple{N,Int})
    prod(shp) == length(a) || throw(DimensionMismatch("Inconsistent array size."))
    ContiguousView(parent(a), offset(a), shp)
end

## ellipview

@compat ellipview{T}(a::DenseArray{T,2}, i::Union{Integer, UnitRange}) = view(a, :, i)
@compat ellipview{T}(a::DenseArray{T,3}, i::Union{Integer, UnitRange}) = view(a, :, :, i)
@compat ellipview{T}(a::DenseArray{T,4}, i::Union{Integer, UnitRange}) = view(a, :, :, :, i)
@compat ellipview{T}(a::DenseArray{T,5}, i::Union{Integer, UnitRange}) = view(a, :, :, :, :, i)
@compat ellipview{T,N}(a::DenseArray{T,N}, i::Union{Integer, UnitRange}) = view(a, ntuple(i->Colon(),N-1)..., i)
