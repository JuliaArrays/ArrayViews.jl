# Testing views of views

using ArrayViews

function print_subs(subs1, subs2)
	println("Error happens on: ")

	subs1s = join([repr(i) for i in subs1], ", ")
	subs2s = join([repr(i) for i in subs2], ", ")

	println("  subs1 = [$subs1s]")
	println("  subs2 = [$subs2s]")
end


function test_view2(a, subs1, subs2)
    v = view(a, subs1...)
    v2 = view(v, subs2...)
    v2r = view(copy(v), subs2...)

    siz_v = size(v2)
    siz_r = size(v2r)

    if siz_v != siz_r
    	print_subs(subs1, subs2)
        error("Incorrect size: get $(siz_v), but expect $(siz_r)")
    end

    for i = 1 : length(v2)
        if v2[i] != v2r[i]         
        	print_subs(subs1, subs2)
            println("v = ")
            println(v)
            println("r = ")
            println(r)
            error("Incorrect content.")
        end
    end
end


# 1D --> 1D

a = rand(8, 7, 6, 5)

for s1 in {(:), 1:36, 2:2:36}
	v1 = view(a, s1)
	for s2 in {4, (:), 1:length(v1), 3:2:length(v1)}
		test_view2(a, (s1,), (s2,))
	end
end

