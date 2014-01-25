module ArrayViews

    import Base: eltype, ndims, size, length, stride, strides
    import Base: to_index, getindex, setindex!, parent, similar

    export ArrayView, ContRank, iscontiguous, contiguousrank
    export ContiguousView, contiguous_view
    export StridedView, strided_view
    export view, contrank

    include("generic.jl")
    include("contiguousview.jl")
    include("stridedview.jl")
    include("contrank.jl")
    include("subviews.jl")

end

