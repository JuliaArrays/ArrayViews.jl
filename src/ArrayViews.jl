module ArrayViews

import Base: eltype, ndims, size, length, stride, strides
import Base: to_index, getindex, setindex!, parent, similar
import Base: Ptr, pointer

if VERSION >= v"0.4.0-dev+2085"
    import Base: iscontiguous
end


if VERSION < v"0.4.0-dev+3768"
    import Base: convert
else
    import Base: unsafe_convert
end

export
    StridedArrayView,
    ArrayView,
    ContiguousView,
    StridedView,
    UnsafeArrayView,
    UnsafeContiguousView,
    UnsafeStridedView,

    ContiguousArray,
    ContiguousVector,
    ContiguousMatrix,

    contiguous_view,
    strided_view,
    view,
    unsafe_view,
    ellipview,
    diagview,
    rowvec_view,
    flatten_view,
    reshape_view,
    iscontiguous,
    contiguousrank

## source files

include("common.jl")
include("arrviews.jl")
include("layout.jl")
include("indexing.jl")
include("contrank.jl")
include("subviews.jl")
include("convenience.jl")

include("deprecates.jl")

end  # module ArrayViews
