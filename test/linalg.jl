using ArrayViews
using Base.Test

avparent = rand(7, 8)
bvparent = rand(8, 5)

_ab = avparent * bvparent

@test _ab == view(avparent, :, :) * bvparent
@test _ab == avparent * view(bvparent, :, :)
@test _ab == view(avparent, :, :) * view(bvparent, :, :)

for j = 1:size(bvparent,2)
    @test_approx_eq _ab[:,j] view(avparent,:,:) * view(bvparent,:,j)
end

@test avparent[:, 2:2:7] * bvparent[1:3, 1:2:5] == view(avparent, :, 2:2:7) * view(bvparent, 1:3, 1:2:5)
