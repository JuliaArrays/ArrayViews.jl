using ArrayViews
using Base.Test
A = reshape(1:12, 4,3)

@test @view(A) == A
@test isa(@view(A[1,1:end]), ArrayView)
@test @view(A[1,1:end]) == A[1,1:end]
@test @view(A[1,:]) == A[1,:]
#check symbol("end") is replaced by length instead of size with only 1 dim indexing
@test @view(A[end-4:end-2]) == A[end-4:end-2]
#check that symbol("end") is not replaced when used in an index in a subexpression
r = 1:2
@test @view(A[1:end, r[1:end]]) == A[1:end, r[1:end]]
#check @view requires an expr of form A[....]
@test_throws ErrorException eval(:(@view((A+A)[1,1:end])))
