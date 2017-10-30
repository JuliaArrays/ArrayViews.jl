using ArrayViews
using Base.Test

avparent = rand(7, 8)
bvparent = rand(8, 5)

_ab = avparent * bvparent

@test _ab == aview(avparent, :, :) * bvparent
@test _ab == avparent * aview(bvparent, :, :)
@test _ab == aview(avparent, :, :) * aview(bvparent, :, :)

for j = 1:size(bvparent,2)
    @test _ab[:,j] ≈ aview(avparent,:,:) * aview(bvparent,:,j)
end

@test avparent[:, 2:2:7] * bvparent[1:3, 1:2:5] == aview(avparent, :, 2:2:7) * aview(bvparent, 1:3, 1:2:5)
