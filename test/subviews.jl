# testing subviews

using ArrayViews

function _test_view(a, r, subs...)
	v = view(a, subs...)

	siz_r = size(r)
	siz_v = size(v)

	if siz_r != siz_v
		error("Incorrect size: get $(siz_v), but expect $(siz_r)")
	end

	for i = 1 : length(v)
		if v[i] != r[i]			
			println("v = ")
			println(v)
			println("r = ")
			println(r)
			error("Incorrect content.")
		end
	end
end

macro test_view(a_, subs...)
	esc(:(_test_view($a_, ($a)[$(subs...)], $(subs...))))
end



#### test views from arrays

const a = reshape(1.:1680., (8, 7, 6, 5))

# 1D

@test_view(a, :)
@test_view(a, 1:12)
@test_view(a, 3:2:36)

# 2D

@test_view(a, :, :)
@test_view(a, :, 2)
@test_view(a, :, 2:8)
@test_view(a, 1:6, 2)
