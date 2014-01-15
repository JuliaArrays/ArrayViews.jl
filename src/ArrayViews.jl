module ArrayViews

    import Base: eltype, ndims, size, length, stride, strides
    import Base: to_index, getindex, setindex!

    export ArrayView, ContiguousView

    include("generic.jl")
    include("contiguousview.jl")

end

