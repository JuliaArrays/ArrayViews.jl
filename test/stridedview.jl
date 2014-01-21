# test stridedview.jl

using ArrayViews
using Base.Test

a = reshape(1.:1680., (8, 7, 6, 5))

### ND=1, CR=1 

v = strided_view(a, 10, (12,), ContRank{1}, (1,))
isa(v, StridedView{Float64, 1, 1})

@test eltype(v) == eltype(a)
@test ndims(v) == 1
@test length(v) == 12
@test iscontiguous(v) == true
@test contiguousrank(v) == 1

@test size(v) == (12,)
@test size(v,1) == 12
@test size(v,2) == 1

@test strides(v) == (1,)
@test stride(v,1) == 1

for i = 1:12
	@test v[i] == a[10 + i]
	@test v[i,1] == a[10 + i]
	@test v[i,1,1] == a[10 + i]
end


### ND=1, CR=0

v = strided_view(a, 10, (12,), ContRank{0}, (2,))
isa(v, StridedView{Float64, 1, 0})

@test eltype(v) == eltype(a)
@test ndims(v) == 1
@test length(v) == 12
@test iscontiguous(v) == false
@test contiguousrank(v) == 0

@test size(v) == (12,)
@test size(v,1) == 12
@test size(v,2) == 1

@test strides(v) == (2,)
@test stride(v,1) == 2

for i = 1:12
	@test v[i] == a[10 + i * 2]
	@test v[i,1] == a[10 + i * 2]
	@test v[i,1,1] == a[10 + i * 2]
end


### ND=2, CR=2

v = strided_view(a, 8, (8, 7), ContRank{2}, (1, 8))
isa(v, StridedView{Float64, 2, 2})

@test eltype(v) == eltype(a)
@test ndims(v) == 2
@test length(v) == 56
@test iscontiguous(v) == true
@test contiguousrank(v) == 2

@test size(v) == (8, 7)
@test size(v,1) == 8
@test size(v,2) == 7
@test size(v,3) == 1

@test strides(v) == (1, 8)
@test stride(v,1) == 1
@test stride(v,2) == 8

i1_ = 0
for j = 1:7, i = 1:8
	@test v[i,j] == a[i,j+1]
	@test v[i,j,1] == a[i,j+1]
	i1_ += 1
	@test v[i1_] == a[i,j+1]
end


### ND=2, CR=1

v = strided_view(a, 8, (6, 7), ContRank{1}, (1, 8))
isa(v, StridedView{Float64, 2, 1})

@test eltype(v) == eltype(a)
@test ndims(v) == 2
@test length(v) == 42
@test iscontiguous(v) == false
@test contiguousrank(v) == 1

@test size(v) == (6, 7)
@test size(v,1) == 6
@test size(v,2) == 7
@test size(v,3) == 1

@test strides(v) == (1, 8)
@test stride(v,1) == 1
@test stride(v,2) == 8

i1_ = 0
for j = 1:7, i = 1:6
	@test v[i,j] == a[i,j+1]
	@test v[i,j,1] == a[i,j+1]
	i1_ += 1
	@test v[i1_] == a[i,j+1]
end


### ND=2, CR=0

v = strided_view(a, 8, (4, 7), ContRank{0}, (2, 8))
isa(v, StridedView{Float64, 2, 0})

@test eltype(v) == eltype(a)
@test ndims(v) == 2
@test length(v) == 28
@test iscontiguous(v) == false
@test contiguousrank(v) == 0

@test size(v) == (4, 7)
@test size(v,1) == 4
@test size(v,2) == 7
@test size(v,3) == 1

@test strides(v) == (2, 8)
@test stride(v,1) == 2
@test stride(v,2) == 8

i1_ = 0
for j = 1:7, i = 1:4
	@test v[i,j] == a[2i-1,j+1]
	@test v[i,j,1] == a[2i-1,j+1]
	i1_ += 1
	@test v[i1_] == a[2i-1,j+1]
end


### ND=3, CR=3

v = strided_view(a, (8, 7, 6), ContRank{3}, (1, 8, 56))
isa(v, StridedView{Float64, 3, 3})

@test eltype(v) == eltype(a)
@test ndims(v) == 3
@test length(v) == 336
@test iscontiguous(v) == true
@test contiguousrank(v) == 3

@test size(v) == (8, 7, 6)
@test size(v,1) == 8
@test size(v,2) == 7
@test size(v,3) == 6
@test size(v,4) == 1

@test strides(v) == (1, 8, 56)
@test stride(v,1) == 1
@test stride(v,2) == 8
@test stride(v,3) == 56

i1_ = 0
i2_ = 0
for k = 1:6, j = 1:7
	i2_ += 1
	for i = 1:8
		@test v[i,j,k] == a[i,j,k]
		@test v[i,j,k,1] == a[i,j,k]

		i1_ += 1
		@test v[i1_] == a[i,j,k]
		@test v[i,i2_] == a[i,j,k]
	end
end


### ND=3, CR=2

v = strided_view(a, (8, 6, 5), ContRank{2}, (1, 8, 56))
isa(v, StridedView{Float64, 3, 2})

@test eltype(v) == eltype(a)
@test ndims(v) == 3
@test length(v) == 240
@test iscontiguous(v) == false
@test contiguousrank(v) == 2

@test size(v) == (8, 6, 5)
@test size(v,1) == 8
@test size(v,2) == 6
@test size(v,3) == 5
@test size(v,4) == 1

@test strides(v) == (1, 8, 56)
@test stride(v,1) == 1
@test stride(v,2) == 8
@test stride(v,3) == 56


i1_ = 0
i2_ = 0
for k = 1:5, j = 1:6
	i2_ += 1
	for i = 1:8
		@test v[i,j,k] == a[i,j,k]
		@test v[i,j,k,1] == a[i,j,k]

		i1_ += 1
		@test v[i1_] == a[i,j,k]
		@test v[i,i2_] == a[i,j,k]
	end
end


### ND=3, CR=1

v = strided_view(a, (7, 6, 5), ContRank{1}, (1, 8, 56))
isa(v, StridedView{Float64, 3, 2})

@test eltype(v) == eltype(a)
@test ndims(v) == 3
@test length(v) == 210
@test iscontiguous(v) == false
@test contiguousrank(v) == 1

@test size(v) == (7, 6, 5)
@test size(v,1) == 7
@test size(v,2) == 6
@test size(v,3) == 5
@test size(v,4) == 1

@test strides(v) == (1, 8, 56)
@test stride(v,1) == 1
@test stride(v,2) == 8
@test stride(v,3) == 56

i1_ = 0
i2_ = 0
for k = 1:5, j = 1:6
	i2_ += 1
	for i = 1:7
		@test v[i,j,k] == a[i,j,k]
		@test v[i,j,k,1] == a[i,j,k]

		i1_ += 1
		@test v[i1_] == a[i,j,k]
		@test v[i,i2_] == a[i,j,k]
	end
end


### ND=3, CR=0

v = strided_view(a, (4, 6, 5), ContRank{0}, (2, 8, 56))
isa(v, StridedView{Float64, 3, 2})

@test eltype(v) == eltype(a)
@test ndims(v) == 3
@test length(v) == 120
@test iscontiguous(v) == false
@test contiguousrank(v) == 0

@test size(v) == (4, 6, 5)
@test size(v,1) == 4
@test size(v,2) == 6
@test size(v,3) == 5
@test size(v,4) == 1

@test strides(v) == (2, 8, 56)
@test stride(v,1) == 2
@test stride(v,2) == 8
@test stride(v,3) == 56

i1_ = 0
i2_ = 0
for k = 1:5, j = 1:6
	i2_ += 1
	for i = 1:4
		@test v[i,j,k] == a[2i-1,j,k]
		@test v[i,j,k,1] == a[2i-1,j,k]

		i1_ += 1
		@test v[i1_] == a[2i-1,j,k]
		@test v[i,i2_] == a[2i-1,j,k]
	end
end



