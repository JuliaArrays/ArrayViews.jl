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

a = reshape(1.:1680., (8, 7, 6, 5))

# 1D

@test_view(a, 3)
@test_view(a, :)
@test_view(a, 1:12)
@test_view(a, 3:2:36)

# 2D

@test_view(a, 4, 2)
@test_view(a, 4, :)
@test_view(a, 4, 3:10)
@test_view(a, 4, 2:2:10)

@test_view(a, :, 2)
@test_view(a, :, :)
@test_view(a, :, 3:10)
@test_view(a, :, 2:2:10)

@test_view(a, 1:6, 2)
@test_view(a, 1:6, :)
@test_view(a, 1:6, 3:10)
@test_view(a, 1:6, 2:2:10)

@test_view(a, 1:2:8, 2)
@test_view(a, 1:2:8, :)
@test_view(a, 1:2:8, 3:10)
@test_view(a, 1:2:8, 2:2:10)

# 3D

@test_view(a, 4, 3, 2)
@test_view(a, 4, 3, :)
@test_view(a, 4, 3, 2:5)
@test_view(a, 4, 3, 1:2:6)

@test_view(a, 4, :, 2)
@test_view(a, 4, :, :)
@test_view(a, 4, :, 2:5)
@test_view(a, 4, :, 1:2:6)

@test_view(a, 4, 3:7, 2)
@test_view(a, 4, 3:7, :)
@test_view(a, 4, 3:7, 2:5)
@test_view(a, 4, 3:7, 1:2:6)

@test_view(a, 4, 1:2:5, 2)
@test_view(a, 4, 1:2:5, :)
@test_view(a, 4, 1:2:5, 2:5)
@test_view(a, 4, 1:2:5, 1:2:6)

@test_view(a, :, 3, 2)
@test_view(a, :, 3, :)
@test_view(a, :, 3, 2:5)
@test_view(a, :, 3, 1:2:6)

@test_view(a, :, :, 2)
@test_view(a, :, :, :)
@test_view(a, :, :, 2:5)
@test_view(a, :, :, 1:2:6)

@test_view(a, :, 3:7, 2)
@test_view(a, :, 3:7, :)
@test_view(a, :, 3:7, 2:5)
@test_view(a, :, 3:7, 1:2:6)

@test_view(a, :, 1:2:5, 2)
@test_view(a, :, 1:2:5, :)
@test_view(a, :, 1:2:5, 2:5)
@test_view(a, :, 1:2:5, 1:2:6)

@test_view(a, 2:7, 3, 2)
@test_view(a, 2:7, 3, :)
@test_view(a, 2:7, 3, 2:5)
@test_view(a, 2:7, 3, 1:2:6)

@test_view(a, 2:7, :, 2)
@test_view(a, 2:7, :, :)
@test_view(a, 2:7, :, 2:5)
@test_view(a, 2:7, :, 1:2:6)

@test_view(a, 2:7, 3:7, 2)
@test_view(a, 2:7, 3:7, :)
@test_view(a, 2:7, 3:7, 2:5)
@test_view(a, 2:7, 3:7, 1:2:6)

@test_view(a, 2:7, 1:2:5, 2)
@test_view(a, 2:7, 1:2:5, :)
@test_view(a, 2:7, 1:2:5, 2:5)
@test_view(a, 2:7, 1:2:5, 1:2:6)

@test_view(a, 1:2:7, 3, 2)
@test_view(a, 1:2:7, 3, :)
@test_view(a, 1:2:7, 3, 2:5)
@test_view(a, 1:2:7, 3, 1:2:6)

@test_view(a, 1:2:7, :, 2)
@test_view(a, 1:2:7, :, :)
@test_view(a, 1:2:7, :, 2:5)
@test_view(a, 1:2:7, :, 1:2:6)

@test_view(a, 1:2:7, 3:7, 2)
@test_view(a, 1:2:7, 3:7, :)
@test_view(a, 1:2:7, 3:7, 2:5)
@test_view(a, 1:2:7, 3:7, 1:2:6)

@test_view(a, 1:2:7, 1:2:5, 2)
@test_view(a, 1:2:7, 1:2:5, :)
@test_view(a, 1:2:7, 1:2:5, 2:5)
@test_view(a, 1:2:7, 1:2:5, 1:2:6)

# Some 4D Tests

@test_view(a, 4, :,     3, 4)
@test_view(a, 4, :,     :, 4)
@test_view(a, 4, :,   3:5, 4)
@test_view(a, 4, :, 1:2:5, 4)

@test_view(a, :, :,     3, 4)
@test_view(a, :, :,     :, 4)
@test_view(a, :, :,   3:5, 4)
@test_view(a, :, :, 1:2:5, 4)

@test_view(a, 2:7, :,     3, 4)
@test_view(a, 2:7, :,     :, 4)
@test_view(a, 2:7, :,   3:5, 4)
@test_view(a, 2:7, :, 1:2:5, 4)

@test_view(a, 1:2:7, :,     3, 4)
@test_view(a, 1:2:7, :,     :, 4)
@test_view(a, 1:2:7, :,   3:5, 4)
@test_view(a, 1:2:7, :, 1:2:5, 4)

@test_view(a, 4, :,     3, :)
@test_view(a, 4, :,     :, :)
@test_view(a, 4, :,   3:5, :)
@test_view(a, 4, :, 1:2:5, :)

@test_view(a, :, :,     3, :)
@test_view(a, :, :,     :, :)
@test_view(a, :, :,   3:5, :)
@test_view(a, :, :, 1:2:5, :)

@test_view(a, 2:7, :,     3, :)
@test_view(a, 2:7, :,     :, :)
@test_view(a, 2:7, :,   3:5, :)
@test_view(a, 2:7, :, 1:2:5, :)

@test_view(a, 1:2:7, :,     3, :)
@test_view(a, 1:2:7, :,     :, :)
@test_view(a, 1:2:7, :,   3:5, :)
@test_view(a, 1:2:7, :, 1:2:5, :)

@test_view(a, 4, :,     3, 2:5)
@test_view(a, 4, :,     :, 2:5)
@test_view(a, 4, :,   3:5, 2:5)
@test_view(a, 4, :, 1:2:5, 2:5)

@test_view(a, :, :,     3, 2:5)
@test_view(a, :, :,     :, 2:5)
@test_view(a, :, :,   3:5, 2:5)
@test_view(a, :, :, 1:2:5, 2:5)

@test_view(a, 2:7, :,     3, 2:5)
@test_view(a, 2:7, :,     :, 2:5)
@test_view(a, 2:7, :,   3:5, 2:5)
@test_view(a, 2:7, :, 1:2:5, 2:5)

@test_view(a, 1:2:7, :,     3, 2:5)
@test_view(a, 1:2:7, :,     :, 2:5)
@test_view(a, 1:2:7, :,   3:5, 2:5)
@test_view(a, 1:2:7, :, 1:2:5, 2:5)

