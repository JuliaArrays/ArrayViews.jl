using ArrayViews
using Base.Test


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
