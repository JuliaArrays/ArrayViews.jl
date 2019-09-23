#### Test Subviews

using ArrayViews, Test

## tools to facilitate aview testing
function _test_arrview_contents(v, r)
    siz_r = size(r)
    siz_v = size(v)
    if siz_r ≠ siz_v
        error("Incorrect size: get $(siz_v), but expect $(siz_r)")
    end

    if length(v) ≠ length(r)
        error("Unmatched length: get $(length(v)), but expect $(length(r))")
    end

    for i = 1 : length(v)
        if v[i] ≠ r[i]
            println("v = ", v)
            println("r = ", r)
            error("Incorrect content.")
        end
    end
end

function _test_arrview(a, r, subs...)
    _test_arrview_contents(aview(a, subs...), r)
    _test_arrview_contents(unsafe_aview(a, subs...), r)
end

macro test_arrview(a_, subs...)
    # ArrayViews still allows omitting indices for non-singleton trailing dims,
    # same as  < Julia 0.6.0, pre #23628.
    # For the sake of getting tests to pass on 0.7, test against old behavior
    esc(:(_test_arrview($a_, reshape($(a_),Val($(length(subs))))[$(subs...)], $(subs...))))
end

#### test views from arrays

avparent = copy(reshape(1.:1680., (8, 7, 6, 5)))

# 1D
println("    -- testing 1D views")

@test_arrview(avparent, 3)
@test_arrview(avparent, :)
@test_arrview(avparent, 1:12)
@test_arrview(avparent, 3:2:36)

# 2D
println("    -- testing 2D views")

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
println("    -- testing 3D views")

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
println("    -- testing 4D views")

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

@test_arrview(avparent, :, 1, 1, 1)
@test_arrview(avparent, :, 1, 2, 1)
@test_arrview(avparent, :, :, 2, 2)
@test_arrview(avparent, :, :, 1:2, 3:4)


# Some 5D tests
println("    -- testing 5D views")

avparent2 = copy(reshape(1.:6720., (8, 7, 6, 5, 4)))

@test_arrview(avparent2, :, 1, 1, 1, 1)
@test_arrview(avparent2, :, 1, 1, 3, 1)
@test_arrview(avparent2, :, 1, 2, 3, 3:4)
@test_arrview(avparent2, 2:7, 1, 1, 1, 3:4)

@test_arrview(avparent2, 1, :, 1, 3, 4)
@test_arrview(avparent2, 2, 3, :, 3, 4)
@test_arrview(avparent2, 3, 4, 5, :, 4)
@test_arrview(avparent2, 2, 3, 4, 4, :)

@test_arrview(avparent2, 1, 2:3, 3, 4, 2)
@test_arrview(avparent2, 2, 1, 3:4, 1, 1)
@test_arrview(avparent2, 3, 1, 1, 4:5, 2)
@test_arrview(avparent2, 4, 1, 1, 3:4, 2:4)

#### Test Subviews of Views

function print_subscripts(subs1, subs2)
    println("Error happens on: ")

    subs1s = join([repr(i) for i in subs1], ", ")
    subs2s = join([repr(i) for i in subs2], ", ")

    println("  subs1 = [$subs1s]")
    println("  subs2 = [$subs2s]")
end

function test_arrview2(a, subs1, subs2)
    v = aview(a, subs1...)
    v2r = aview(copy(v), subs2...)
    _test_arrview_contents(aview(v, subs2...), v2r)
    uv = unsafe_aview(a, subs1...)
    _test_arrview_contents(unsafe_aview(uv, subs2...), v2r)
end

avparent = copy(reshape(1:6912, (12, 12, 8, 6)))

# 1D --> 1D
println("    -- testing 1D sub-views of 1D views")

for sa in Any[Colon(), 1:36, 2:2:36]
    v1 = aview(avparent, sa)
    for sb in Any[4, Colon(), 1:length(v1), 3:2:length(v1)]
        test_arrview2(avparent, (sa,), (sb,))
    end
end

# 2D --> 2D
println("    -- testing 2D sub-views of 2D views")

for sa1 in Any[Colon(), 1:10, 2:2:12], sa2 = Any[Colon(), 1:12, 2:2:16]
    v1 = aview(avparent, sa1, sa2)
    for sb1 in Any[4, Colon(), 2:size(v1,1), 2:2:size(v1,1)],
        sb2 in Any[4, Colon(), 2:size(v1,2), 2:2:size(v1,2)]
        test_arrview2(avparent, (sa1, sa2), (sb1, sb2))
    end
end

# 3D --> 3D
println("    -- testing 3D sub-views of 3D views")

for sa1 in Any[Colon(), 1:10, 2:2:12],
    sa2 in Any[Colon(), 1:10, 2:2:12],
    sa3 in Any[Colon(), 1:7, 2:2:8]
    v1 = aview(avparent, sa1, sa2, sa3)
    (d1, d2, d3) = size(v1)
    for sb1 in Any[Colon(), 2:d1, 2:2:d1],
        sb2 in Any[Colon(), 2:d2, 2:2:d2],
        sb3 in Any[Colon(), 2:d3, 2:2:d3]
        test_arrview2(avparent, (sa1, sa2, sa3), (sb1, sb2, sb3))
    end
end
