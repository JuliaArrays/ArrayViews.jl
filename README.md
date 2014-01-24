ArrayViews.jl
=============

A Julia package to explore a new system of array views.
[![Build Status](https://travis-ci.org/lindahua/ArrayViews.jl.png)](https://travis-ci.org/lindahua/ArrayViews.jl)


-----------------------------

Main Features
--------------

- An efficient ``view`` function that implements array views
- Support of arrays of arbitrary dimension and arbitrary combinations of indexers
- Support view composition (*i.e.* construct views over views)
- Special attention to ensure type stability in most cases
- Efficient indexing (both cartesian and linear)
- Light weight view construction
- A systematic approach to detect contiguous views (statically)


Function and View Types
-------------------------

The key function in this package is ``view``. This function is similar to ``sub`` in Julia Base, except that it returns an view instance with more efficient representation:

```julia
a = rand(4, 5, 6)

view(a, :)
view(a, :, 2)
view(a, 1:2, 1:2:5, 4)
view(a, 2, :, 3:6)
```

The package has two view types ``ContiguousView`` and ``StridedView``. They are respectively defined as follows:

- ``ContiguousView`` is used to represent a view of an array (or a part of an array) that has contiguous memory layout:

    ```julia
    immutable ContiguousView{T,N,Arr<:Array{T}} <: ArrayView{T,N,N}
        arr::Arr               # underlying array
        offset::Int            # offset relative to the arr's origin
        len::Int               # number of elements
        shp::NTuple{N,Int}     # view shape
    end
    ```
    Here, ``T`` is the element type, ``N`` is the number of dimensions, and ``Arr`` is the type of the underlying array.


- ``StridedView`` is used to represent a view of an array (or a part of an array) that is not necessarily contiguous (*i.e.*, the contiguousness cannot be determined statically).

    ```julia
    immutable StridedView{T,N,M,Arr<:Array{T}} <: ArrayView{T,N,M}
        arr::Arr                  # underlying array
        offset::Int               # offset relative to arr's origin
        len::Int                  # number of elements
        shp::NTuple{N,Int}        # view shape
        strides::NTuple{N,Int}    # strides of all dimensions
    end
    ```
    Here, ``M`` is called the *contiguous rank*, which plays an important role in determining (statically) the contiguousness of a subview.The notion of *contiguous rank* will be explained later.

