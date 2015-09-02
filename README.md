# ArrayViews.jl

[![Build Status](https://travis-ci.org/JuliaLang/ArrayViews.jl.svg)](https://travis-ci.org/JuliaLang/ArrayViews.jl)
[![Coverage Status](https://coveralls.io/repos/JuliaLang/ArrayViews.jl/badge.svg)](https://coveralls.io/r/JuliaLang/ArrayViews.jl)

[![ArrayViews](http://pkg.julialang.org/badges/ArrayViews_0.3.svg)](http://pkg.julialang.org/?pkg=ArrayViews&ver=0.3)
[![ArrayViews](http://pkg.julialang.org/badges/ArrayViews_0.4.svg)](http://pkg.julialang.org/?pkg=ArrayViews&ver=0.4)

A Julia package to explore a new system of array views.


-----------------------------

## Main Features

- An efficient ``view`` function that implements array views
- Support of arrays of arbitrary dimension and arbitrary combinations of indexers
- Support view composition (*i.e.* construct views over views)
- Special attention to ensure type stability in most cases
- Efficient indexing (both cartesian and linear)
- Light weight view construction
- A systematic approach to detect contiguous views (statically)
- Views work with linear algebra functions


## Overview

The key function in this package is ``view``. This function is similar to ``sub`` in Julia Base, except that it returns an view instance with more efficient representation:

```julia
a = rand(4, 5, 6)

view(a, :)
view(a, :, 2)
view(a, 1:2, 1:2:5, 4)
view(a, 2, :, 3:6)
```

The ``view`` function returns a view of type ``ArrayView``. Here, ``ArrayView`` is an abstract type with two derived types (``ContiguousView`` and ``StridedView``), defined as:

```julia
abstract ArrayView{T,N,M} <: DenseArray{T,N}
```
We can see that each view type has three static properties: element type ``T``, the number of dimensions ``N``, and the *contiguous rank* ``M``.

#### Contiguous Rank

The *contiguous rank* plays an important role in determining (statically) the contiguousness of a subview. Below are illustrations of 2D views respective with contiguous rank ``0``, ``1``, and ``2``.

**2D View with contiguous rank 0**

```
* * * * * *
. . . . . .
* * * * * *
. . . . . .
* * * * * *
. . . . . .
```
Here, ``*`` indicates a position covered by the view, and ``.`` otherwise. We can see that the columns are not contiguous.

**2D View with contiguous rank 1**

```
* * * * * *
* * * * * *
* * * * * *
* * * * * *
. . . . . .
. . . . . .
```
We can see that each column is contiguous, while the entire view is not.


**2D View with contiguous rank 2**

```
* * * * * *
* * * * * *
* * * * * *
* * * * * *
* * * * * *
* * * * * *
```
The entire 2D view is contiguous.


Formally, when ``v`` is a view with contiguous rank ``M``, then ``view(v, :, :, ..., :, 1)`` must be contiguous when the number of colons is less than or equal to ``M``.


#### View Types

The package provide a hierarchy of view types (defined as follows):

```julia
# T: the element type
# N: the number of dimensions
# M: the contiguous rank

abstract StridedArrayView{T,N,M} <: DenseArray{T,N}
abstract ArrayView{T,N,M} <: StridedArrayView{T,N,M}
abstract UnsafeArrayView{T,N,M} <: StridedArrayView{T,N,M}

immutable ContiguousView{T,N,Arr<:Array} <: ArrayView{T,N,N}
immutable StridedView{T,N,M,Arr<:Array} <: ArrayView{T,N,M}

immutable UnsafeContiguousView{T,N} <: UnsafeArrayView{T,N,N}
immutable UnsafeStridedView{T,N,M} <: UnsafeArrayView{T,N,M}
```

Here, an instance of ``ArrayView`` maintains a reference to the underlying array, and is generally safe to use in most cases. An instance of ``UnsafeArrayView`` maintains a raw pointer, and should only be used within a local scope (as it does not guarantee that the source array remains valid if it is passed out of a function).


#### View Types in Action

The following example illustrates how contiguous rank is used to determine view types in practice.

```julia
a = rand(m, n)

# safe views

v0 = view(a, :)         # of type ContiguousView{Float64, 1}

u1 = view(a, a:b, :)    # of type StridedView{Float64, 2, 1}
u2 = view(u1, :, i)     # of type ContiguousView{Float64, 1}

v1 = view(a, a:2:b, :)  # of type StridedView{Float64, 2, 0}
v2 = view(v1, :, i)     # of type StridedView{Float64, 1, 0}

# unsafe views

v0 = unsafe_view(a, :)         # of type UnsafeContiguousView{Float64, 1}

u1 = unsafe_view(a, a:b, :)    # of type UnsafeStridedView{Float64, 2, 1}
u2 = unsafe_view(u1, :, i)     # of type UnsafeContiguousView{Float64, 1}

v1 = unsafe_view(a, a:2:b, :)  # of type UnsafeStridedView{Float64, 2, 0}
v2 = unsafe_view(v1, :, i)     # of type UnsafeStridedView{Float64, 1, 0}
```

Four kinds of indexers are supported, integer, range (*e.g.* ``a:b``), stepped range (*e.g.* ``a:b:c``), and colon (*i.e.*, ``:``).
Unlike the ``sub`` function in Julia Base, the colon ``:`` is specially treated rather than converted to ``1:size(v,d)``, as it plays a crucial role in determining contiguousness. For example, the contiguous rank of ``view(a, :, a:b)`` is 2, while that of ``view(a, i:j, a:b)`` is 1.


## View Construction

The procedure of constructing a view consists of several steps:

1. Compute the shape of a view. This is done by an internal function ``vshape``.

2. Compute the offset of a view. This is done by an internal function ``aoffset``. The computation is based on the following formula:

    ```
    offset(v(I1, I2, ..., Im)) = (first(I1) - 1) * stride(v, 1)
                               + (first(I2) - 1) * stride(v, 2)
                               + ...
                               + (first(Im) - 1) * stride(v, m)
    ```

3. Compute the contiguous rank, based on both view shape and the combination of indexer types. A type ``ContRank{M}`` is introduced for static computation of contiguous rank (please refer to ``src/contrank.jl`` for details).

4. Construct a view, where the view type is determined by both the number of dimensions and the value of contiguous rank (which is determined statically).

For runtime efficiency, specialized methods of these functions are implemented for views of 1D, 2D, and 3D. These methods are extensively tested.


## Convenience Functions

The *ArrayViews* package provides several functions to make it more convenient to constructing certain views:

```julia

diagview(a)   # make a strided view of the diagonal elements, the length is `min(size(a)...)`
              # `a` needs to be a matrix here (contiguous or strided)

flatten_view(a)   # make a contiguous view of `a` as a vector
                  # `a` needs to be contiguous here

reshape_view(a, shp)   # make a contiguous view of `a` of shape `shp`
                       # `a` needs to be contiguous here.

rowvec_view(a, i)   # make a view of `a[i,:]` as a strided vector.
                    # `a` needs to be a matrix here (contiguous or strided)

ellipview(a, i)     # make a view of the i-th slice of a
                    # e.g. `a` is a matrix => this is equiv. to `view(a, :, i)`
                    #      `a` is a cube => this is equiv. to `view(a, :, :, i)`, etc.
```
