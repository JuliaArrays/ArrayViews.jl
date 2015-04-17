using ArrayViews
using Base.Test

#### diagview

a = rand(5, 6)
@test diagview(a) == diag(a)
a = rand(6, 6)
@test diagview(a) == diag(a)
a = rand(6, 5)
@test diagview(a) == diag(a)


#### flatten_view

a = rand(5, 6)
@test flatten_view(a) == vec(a)


#### rowvec_view

a = rand(4, 5)
for i = 1:size(a,1)
    @test rowvec_view(a, i) == vec(a[i,:])
end

a = rand(6, 8)
b = view(a, 2:6, 2:7)
for i = 1:size(b,1)
    @test rowvec_view(b,i) == vec(a[1+i, 2:7])
end


#### reshape_view

a = rand(3, 6)
v1 = reshape_view(a, (2, 9))
@test size(v1) == (2, 9)
@test v1 == reshape(a, (2, 9))
v2 = reshape_view(a, (6, 3))
@test size(v2) == (6, 3)
@test v2 == reshape(a, (6, 3))

#### ellipview

a = rand(10)
@test isequal(view(a, 5), ellipview(a, 5))
@test isequal(view(a, 2:3), ellipview(a, 2:3))
a = rand(10,20)
@test isequal(view(a, :, 5), ellipview(a, 5))
@test isequal(view(a, :, 2:3), ellipview(a, 2:3))
a = rand(10,20,30)
@test isequal(view(a, :, :, 5), ellipview(a, 5))
@test isequal(view(a, :, :, 2:3), ellipview(a, 2:3))
a = rand(10,20,30,40)
@test isequal(view(a, :, :, :, 5), ellipview(a, 5))
@test isequal(view(a, :, :, :, 2:3), ellipview(a,2:3))
