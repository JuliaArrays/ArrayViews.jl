module ArrayViews

    import Base: eltype, ndims, size, length, stride, strides
    import Base: to_index, getindex, setindex!

    export ArrayView
    export ContiguousView, contiguous_view

    include("generic.jl")
    include("contiguousview.jl")

end

