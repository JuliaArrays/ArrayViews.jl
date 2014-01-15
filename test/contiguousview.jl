# test contiguousview.jl

using ArrayViews
using Base.Test

a = rand(5, 4, 3, 2)

## 1D

v = ContiguousView(a, 10, (20,))

@test eltype(v) == eltype(a)
@test ndims(v) == 1

@test length(v) == 20

@test size(v) == (20,)
@test size(v,1) == 20
@test size(v,2) == 1

@test strides(v) == (1,)
@test stride(v,1) == 1
@test stride(v,2) == 20
@test stride(v,3) == 20

for i = 1:20
    @test v[i] == a[10 + i]
    @test v[i,1] == a[10 + i]
end

## 2D

v = ContiguousView(a, 10, (5, 12))

@test eltype(v) == eltype(a)
@test ndims(v) == 2

@test length(v) == 60

@test size(v) == (5, 12)
@test size(v,1) == 5
@test size(v,2) == 12
@test size(v,3) == 1

@test strides(v) == (1,5)
@test stride(v,1) == 1
@test stride(v,2) == 5
@test stride(v,3) == 60
@test stride(v,4) == 60

for i = 1:60
    @test v[i] == a[10 + i]
end

for j = 1:12, i = 1:5
    @test v[i,j] == a[i,j+2]
    @test v[i,j,1] == a[i,j+2]
end

## 3D

v = ContiguousView(a, 0, (5, 4, 6))

@test eltype(v) == eltype(a)
@test ndims(v) == 3

@test length(v) == 120

@test size(v) == (5, 4, 6)
@test size(v,1) == 5
@test size(v,2) == 4
@test size(v,3) == 6
@test size(v,4) == 1

@test strides(v) == (1,5,20)
@test stride(v,1) == 1
@test stride(v,2) == 5
@test stride(v,3) == 20
@test stride(v,4) == 120
@test stride(v,5) == 120

for i = 1:120
    @test v[i] == a[i]
end

for j = 1:24, i = 1:5
    @test v[i,j] == a[i,j]
end

for k = 1:6, j=1:4, i=1:5
    @test v[i,j,k] == a[i,j,k]
    @test v[i,j,k,1] == a[i,j,k]
end

## 4D

v = ContiguousView(a, 0, (5, 4, 3, 2))

@test eltype(v) == eltype(a)
@test ndims(v) == 4

@test length(v) == 120

@test size(v) == (5, 4, 3, 2)
@test size(v,1) == 5
@test size(v,2) == 4
@test size(v,3) == 3
@test size(v,4) == 2
@test size(v,5) == 1

@test strides(v) == (1,5,20,60)
@test stride(v,1) == 1
@test stride(v,2) == 5
@test stride(v,3) == 20
@test stride(v,4) == 60
@test stride(v,5) == 120
@test stride(v,6) == 120

for i = 1:120
    @test v[i] == a[i]
end

for j = 1:24, i = 1:5
    @test v[i,j] == a[i,j]
end

for k = 1:6, j=1:4, i=1:5
    @test v[i,j,k] == a[i,j,k]
end

for l = 1:2, k = 1:3, j=1:4, i=1:5
    @test v[i,j,k,l] == a[i,j,k,l]
end


