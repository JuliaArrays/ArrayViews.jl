# functions for convenience of use

## reshape_view

function reshape_view{N}(a::ContiguousArray, shp::NTuple{N,Int})
    prod(shp) == length(a) || throw(DimensionMismatch("Inconsistent array size."))
    contiguous_view(parent(a), offset(a), shp)
end


## ellipview

ellipview{T}(a::DenseArray{T,2}, i::Union(Integer, Range1)) = view(a, :, i)
ellipview{T}(a::DenseArray{T,3}, i::Union(Integer, Range1)) = view(a, :, :, i)
ellipview{T}(a::DenseArray{T,4}, i::Union(Integer, Range1)) = view(a, :, :, :, i)
ellipview{T}(a::DenseArray{T,5}, i::Union(Integer, Range1)) = view(a, :, :, :, :, i)
ellipview{T,N}(a::DenseArray{T,N}, i::Union(Integer, Range1)) = view(a, ntuple(N-1, i->Colon())..., i)
