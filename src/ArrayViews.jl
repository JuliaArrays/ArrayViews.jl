module ArrayViews

import Base: eltype, ndims, size, length, stride, strides
import Base: to_index, getindex, setindex!, parent, similar
import Base: Ptr, pointer
if VERSION < v"0.4.0-dev+3768"
    import Base: convert
else
    import Base: unsafe_convert
end

export ArrayView, ContiguousView, StridedView
export ContiguousArray, ContiguousVector, ContiguousMatrix
export contiguous_view, strided_view, view, ellipview, reshape_view
export iscontiguous, contiguousrank

## source files

include("common.jl")
include("contiguousviews.jl")
include("stridedviews.jl")
include("contrank.jl")
include("subviews.jl")
include("convenience.jl")

end  # module ArrayViews
