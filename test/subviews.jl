# testing subviews

using ArrayViews

## tools to facilitate array view testing

function _test_arrview(a, r, subs...)
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

macro test_arrview(a_, subs...)
    esc(:(_test_arrview($a_, ($a_)[$(subs...)], $(subs...))))
end

#### test views from arrays

avparent = reshape(1.:1680., (8, 7, 6, 5))

# 1D
@test_arrview(avparent, 3)
@test_arrview(avparent, :)
@test_arrview(avparent, 1:12)
@test_arrview(avparent, 3:2:36)

# 2D
@test_arrview(avparent, 4, 2)
@test_arrview(avparent, 4, :)
@test_arrview(avparent, 4, 3:10)
@test_arrview(avparent, 4, 2:2:10)

@test_arrview(avparent, :, 2)
@test_arrview(avparent, :, :)
@test_arrview(avparent, :, 3:10)
@test_arrview(avparent, :, 2:2:10)

@test_arrview(avparent, 1:6, 2)
@test_arrview(avparent, 1:6, :)
@test_arrview(avparent, 1:6, 3:10)
@test_arrview(avparent, 1:6, 2:2:10)

@test_arrview(avparent, 1:2:8, 2)
@test_arrview(avparent, 1:2:8, :)
@test_arrview(avparent, 1:2:8, 3:10)
@test_arrview(avparent, 1:2:8, 2:2:10)

# 3D
@test_arrview(avparent, 4, 3, 2)
@test_arrview(avparent, 4, 3, :)
@test_arrview(avparent, 4, 3, 2:5)
@test_arrview(avparent, 4, 3, 1:2:6)

@test_arrview(avparent, 4, :, 2)
@test_arrview(avparent, 4, :, :)
@test_arrview(avparent, 4, :, 2:5)
@test_arrview(avparent, 4, :, 1:2:6)

@test_arrview(avparent, 4, 3:7, 2)
@test_arrview(avparent, 4, 3:7, :)
@test_arrview(avparent, 4, 3:7, 2:5)
@test_arrview(avparent, 4, 3:7, 1:2:6)

@test_arrview(avparent, 4, 1:2:5, 2)
@test_arrview(avparent, 4, 1:2:5, :)
@test_arrview(avparent, 4, 1:2:5, 2:5)
@test_arrview(avparent, 4, 1:2:5, 1:2:6)

@test_arrview(avparent, :, 3, 2)
@test_arrview(avparent, :, 3, :)
@test_arrview(avparent, :, 3, 2:5)
@test_arrview(avparent, :, 3, 1:2:6)

@test_arrview(avparent, :, :, 2)
@test_arrview(avparent, :, :, :)
@test_arrview(avparent, :, :, 2:5)
@test_arrview(avparent, :, :, 1:2:6)

@test_arrview(avparent, :, 3:7, 2)
@test_arrview(avparent, :, 3:7, :)
@test_arrview(avparent, :, 3:7, 2:5)
@test_arrview(avparent, :, 3:7, 1:2:6)

@test_arrview(avparent, :, 1:2:5, 2)
@test_arrview(avparent, :, 1:2:5, :)
@test_arrview(avparent, :, 1:2:5, 2:5)
@test_arrview(avparent, :, 1:2:5, 1:2:6)

@test_arrview(avparent, 2:7, 3, 2)
@test_arrview(avparent, 2:7, 3, :)
@test_arrview(avparent, 2:7, 3, 2:5)
@test_arrview(avparent, 2:7, 3, 1:2:6)

@test_arrview(avparent, 2:7, :, 2)
@test_arrview(avparent, 2:7, :, :)
@test_arrview(avparent, 2:7, :, 2:5)
@test_arrview(avparent, 2:7, :, 1:2:6)

@test_arrview(avparent, 2:7, 3:7, 2)
@test_arrview(avparent, 2:7, 3:7, :)
@test_arrview(avparent, 2:7, 3:7, 2:5)
@test_arrview(avparent, 2:7, 3:7, 1:2:6)

@test_arrview(avparent, 2:7, 1:2:5, 2)
@test_arrview(avparent, 2:7, 1:2:5, :)
@test_arrview(avparent, 2:7, 1:2:5, 2:5)
@test_arrview(avparent, 2:7, 1:2:5, 1:2:6)

@test_arrview(avparent, 1:2:7, 3, 2)
@test_arrview(avparent, 1:2:7, 3, :)
@test_arrview(avparent, 1:2:7, 3, 2:5)
@test_arrview(avparent, 1:2:7, 3, 1:2:6)

@test_arrview(avparent, 1:2:7, :, 2)
@test_arrview(avparent, 1:2:7, :, :)
@test_arrview(avparent, 1:2:7, :, 2:5)
@test_arrview(avparent, 1:2:7, :, 1:2:6)

@test_arrview(avparent, 1:2:7, 3:7, 2)
@test_arrview(avparent, 1:2:7, 3:7, :)
@test_arrview(avparent, 1:2:7, 3:7, 2:5)
@test_arrview(avparent, 1:2:7, 3:7, 1:2:6)

@test_arrview(avparent, 1:2:7, 1:2:5, 2)
@test_arrview(avparent, 1:2:7, 1:2:5, :)
@test_arrview(avparent, 1:2:7, 1:2:5, 2:5)
@test_arrview(avparent, 1:2:7, 1:2:5, 1:2:6)

# Some 4D Tests
@test_arrview(avparent, 4, :,     3, 4)
@test_arrview(avparent, 4, :,     :, 4)
@test_arrview(avparent, 4, :,   3:5, 4)
@test_arrview(avparent, 4, :, 1:2:5, 4)

@test_arrview(avparent, :, :,     3, 4)
@test_arrview(avparent, :, :,     :, 4)
@test_arrview(avparent, :, :,   3:5, 4)
@test_arrview(avparent, :, :, 1:2:5, 4)

@test_arrview(avparent, 2:7, :,     3, 4)
@test_arrview(avparent, 2:7, :,     :, 4)
@test_arrview(avparent, 2:7, :,   3:5, 4)
@test_arrview(avparent, 2:7, :, 1:2:5, 4)

@test_arrview(avparent, 1:2:7, :,     3, 4)
@test_arrview(avparent, 1:2:7, :,     :, 4)
@test_arrview(avparent, 1:2:7, :,   3:5, 4)
@test_arrview(avparent, 1:2:7, :, 1:2:5, 4)

@test_arrview(avparent, 4, :,     3, :)
@test_arrview(avparent, 4, :,     :, :)
@test_arrview(avparent, 4, :,   3:5, :)
@test_arrview(avparent, 4, :, 1:2:5, :)

@test_arrview(avparent, :, :,     3, :)
@test_arrview(avparent, :, :,     :, :)
@test_arrview(avparent, :, :,   3:5, :)
@test_arrview(avparent, :, :, 1:2:5, :)

@test_arrview(avparent, 2:7, :,     3, :)
@test_arrview(avparent, 2:7, :,     :, :)
@test_arrview(avparent, 2:7, :,   3:5, :)
@test_arrview(avparent, 2:7, :, 1:2:5, :)

@test_arrview(avparent, 1:2:7, :,     3, :)
@test_arrview(avparent, 1:2:7, :,     :, :)
@test_arrview(avparent, 1:2:7, :,   3:5, :)
@test_arrview(avparent, 1:2:7, :, 1:2:5, :)

@test_arrview(avparent, 4, :,     3, 2:5)
@test_arrview(avparent, 4, :,     :, 2:5)
@test_arrview(avparent, 4, :,   3:5, 2:5)
@test_arrview(avparent, 4, :, 1:2:5, 2:5)

@test_arrview(avparent, :, :,     3, 2:5)
@test_arrview(avparent, :, :,     :, 2:5)
@test_arrview(avparent, :, :,   3:5, 2:5)
@test_arrview(avparent, :, :, 1:2:5, 2:5)

@test_arrview(avparent, 2:7, :,     3, 2:5)
@test_arrview(avparent, 2:7, :,     :, 2:5)
@test_arrview(avparent, 2:7, :,   3:5, 2:5)
@test_arrview(avparent, 2:7, :, 1:2:5, 2:5)

@test_arrview(avparent, 1:2:7, :,     3, 2:5)
@test_arrview(avparent, 1:2:7, :,     :, 2:5)
@test_arrview(avparent, 1:2:7, :,   3:5, 2:5)
@test_arrview(avparent, 1:2:7, :, 1:2:5, 2:5)

