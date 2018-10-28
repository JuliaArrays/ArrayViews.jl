__precompile__(true)

module ArrayViews

using Compat

import Base: eltype, ndims, size, length, stride, strides
import Base: to_index, getindex, setindex!, parent, similar
import Base: Ptr, pointer
import Base: iscontiguous, convert, unsafe_convert
import Base: _sub2ind, _ind2sub

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
    aview,
    astride,
    unsafe_aview,
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
