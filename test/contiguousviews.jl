using ArrayViews
using Base.Test

import ArrayViews.ContRank

avparent = rand(5, 4, 3, 2)

## 1D
v = contiguous_view(avparent, 10, (20,))
@test isa(v, ContiguousView{Float64,1})
@test eltype(v) == eltype(avparent)
@test ndims(v) == 1
@test length(v) == 20

@test size(v) == (20,)
@test [size(v,i) for i=1:2] == [20, 1]
@test strides(v) == (1,)
@test [stride(v,i) for i=1:2] == [1,20]

@test [v[i] for i=1:20] == avparent[11:30]
@test [v[i,1] for i=1:20] == avparent[11:30]

## 2D
v = contiguous_view(avparent, 10, (5, 12))
@test isa(v, ContiguousView{Float64,2})
@test eltype(v) == eltype(avparent)
@test ndims(v) == 2
@test length(v) == 60

@test size(v) == (5, 12)
@test [size(v,i) for i=1:3] == [5,12,1]
@test strides(v) == (1,5)
@test [stride(v,i) for i=1:3] == [1,5,60]

@test [v[i] for i=1:60] == avparent[11:70]
@test [v[i,j] for i=1:5, j=1:12] == avparent[:,3:14]
@test [v[i,j,1] for i=1:5, j=1:12] == avparent[:,3:14]

## 3D
v = contiguous_view(avparent, (5, 4, 6))
@test isa(v, ContiguousView{Float64,3})
@test eltype(v) == eltype(avparent)
@test ndims(v) == 3
@test length(v) == 120

@test size(v) == (5, 4, 6)
@test [size(v,i) for i=1:4] == [5,4,6,1]
@test strides(v) == (1,5,20)
@test [stride(v,i) for i=1:4] == [1,5,20,120]

@test [v[i] for i=1:120] == avparent[1:120]
@test [v[i,j] for i=1:5, j=1:24] == avparent[1:5,1:24]
@test [v[i,j,k] for i=1:5, j=1:4, k=1:6] == avparent[1:5, 1:4, 1:6]
@test [v[i,j,k,1] for i=1:5, j=1:4, k=1:6] == avparent[1:5, 1:4, 1:6]

## 4D
v = contiguous_view(avparent, 0, (5, 4, 3, 2))
@test isa(v, ContiguousView{Float64,4})
@test eltype(v) == eltype(avparent)
@test ndims(v) == 4
@test length(v) == 120

@test size(v) == (5, 4, 3, 2)
@test [size(v,i) for i=1:5] == [5,4,3,2,1]
@test strides(v) == (1,5,20,60)
@test [stride(v,i) for i=1:5] == [1,5,20,60,120]

@test [v[i] for i=1:120] == avparent[1:120]
@test [v[i,j] for i=1:5, j=1:24] == avparent[1:5, 1:24]
@test [v[i,j,k] for i=1:5, j=1:4, k=1:6] == avparent[1:5, 1:4, 1:6]
@test [v[i,j,k,l] for i=1:5, j=1:4, k=1:3, l=1:2] == avparent[1:5, 1:4, 1:3, 1:2]
@test [v[i,j,k,l,1] for i=1:5, j=1:4, k=1:3, l=1:2] == avparent[1:5, 1:4, 1:3, 1:2]
