using ArrayViews, Test, LinearAlgebra

println("    -- testing linalg")

avparent = rand(7, 8)
bvparent = rand(8, 5)

_ab = avparent * bvparent

@test _ab == aview(avparent, :, :) * bvparent
@test _ab == unsafe_aview(avparent, :, :) * bvparent

@test _ab == avparent * aview(bvparent, :, :)
@test _ab == avparent * unsafe_aview(bvparent, :, :)

@test _ab == aview(avparent, :, :) * aview(bvparent, :, :)
@test _ab == aview(avparent, :, :) * unsafe_aview(bvparent, :, :)

for j = 1:size(bvparent,2)
    @test _ab[:,j] ≈ aview(avparent,:,:) * aview(bvparent,:,j)
    @test _ab[:,j] ≈ aview(avparent,:,:) * unsafe_aview(bvparent,:,j)
end

# @test avparent[:, 2:2:6] * bvparent[1:3, 1:2:5] == aview(avparent, :, 2:2:6) * aview(bvparent, 1:3, 1:2:5)
# @test avparent[:, 2:2:6] * bvparent[1:3, 1:2:5] == unsafe_aview(avparent, :, 2:2:6) * unsafe_aview(bvparent, 1:3, 1:2:5)

cvparent = rand(2, 3)
dvparent = rand(3, 2)

@test cvparent[1:2, 1:2:3] * dvparent[1:2:3, 1:2] == aview(cvparent, 1:2, 1:2:3) * aview(dvparent, 1:2:3, 1:2)
@test cvparent[1:2, 1:2:3] * dvparent[1:2:3, 1:2] == unsafe_aview(cvparent, 1:2, 1:2:3) * unsafe_aview(dvparent, 1:2:3, 1:2)

evparent = rand(3, 3)
fvparent = rand(3, 3)

@test evparent[1:2:3, 1:2:3] * fvparent[1:2:3, 1:2:3] == aview(evparent, 1:2:3, 1:2:3) * aview(fvparent, 1:2:3, 1:2:3)
@test evparent[1:2:3, 1:2:3] * fvparent[1:2:3, 1:2:3] == unsafe_aview(evparent, 1:2:3, 1:2:3) * unsafe_aview(fvparent, 1:2:3, 1:2:3)

@test evparent[1:2:3, 1:2:3] * fvparent[1:2, 1:2:3] == aview(evparent, 1:2:3, 1:2:3) * aview(fvparent, 1:2, 1:2:3)
@test evparent[1:2:3, 1:2:3] * fvparent[1:2, 1:2:3] == unsafe_aview(evparent, 1:2:3, 1:2:3) * unsafe_aview(fvparent, 1:2, 1:2:3)
