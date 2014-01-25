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
            println(v2)
            println("r = ")
            println(v2r)
            error("Incorrect content.")
        end
    end
end


a = rand(12, 12, 8, 6)

# 1D --> 1D

for sa in {(:), 1:36, 2:2:36}
    v1 = view(a, sa)
    for sb in {4, (:), 1:length(v1), 3:2:length(v1)}
        test_view2(a, (sa,), (sb,))
    end
end

# 2D --> 2D

for sa1 in {(:), 1:10, 2:2:12}, sa2 = {(:), 1:12, 2:2:16}
    v1 = view(a, sa1, sa2)
    for sb1 in {4, (:), 2:size(v1,1), 2:2:size(v1,1)}, 
        sb2 in {4, (:), 2:size(v1,2), 2:2:size(v1,2)}
        test_view2(a, (sa1, sa2), (sb1, sb2))
    end
end

# 3D --> 3D

for sa1 in {(:), 1:10, 2:2:12}, 
    sa2 in {(:), 1:10, 2:2:12}, 
    sa3 in {(:), 1:7, 2:2:8}

    v1 = view(a, sa1, sa2, sa3)
    (d1, d2, d3) = size(v1)

    for sb1 in {(:), 2:d1, 2:2:d1}, 
        sb2 in {(:), 2:d2, 2:2:d2}, 
        sb3 in {(:), 2:d3, 2:2:d3}

        test_view2(a, (sa1, sa2, sa3), (sb1, sb2, sb3))
    end
end

