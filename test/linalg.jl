# Test linear algebra on views

using ArrayViews
using Base.Test

a = rand(7, 8)
b = rand(8, 5)

ab = a * b

@test ab == view(a, :, :) * b
@test ab == a * view(b, :, :)
@test ab == view(a, :, :) * view(b, :, :)

for j = 1:size(b,2)
    @test_approx_eq ab[:,j] view(a,:,:) * view(b,:,j)
end

@test a[:, 2:2:7] * b[1:3, 1:2:5] == view(a, :, 2:2:7) * view(b, 1:3, 1:2:5)
