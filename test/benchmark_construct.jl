# Benchmark on view construction (overhead)

using ArrayViews

function traverse_row_subs(a::Array, r::Int)
    m = size(a, 1)
    for _ = 1:r, i = 1:m
        sub(a, i, :)
    end
end

function traverse_row_views(a::Array, r::Int)
    m = size(a, 1)
    for _ = 1:r, i = 1:m
        view(a, i, :)
    end
end

function traverse_row_unsafeviews(a::Array, r::Int)
    m = size(a, 1)
    for _ = 1:r, i = 1:m
        unsafe_aview(a, i, :)
    end
end

function traverse_column_subs(a::Array, r::Int)
    n = size(a, 2)
    for _ = 1:r, i = 1:n
        sub(a, :, i)
    end
end

function traverse_column_views(a::Array, r::Int)
    n = size(a, 2)
    for _ = 1:r, i = 1:n
        view(a, :, i)
    end
end

function traverse_column_unsafeviews(a::Array, r::Int)
    n = size(a, 2)
    for _ = 1:r, i = 1:n
        unsafe_aview(a, :, i)
    end
end


## data

const a1 = rand(1000, 5)
const a2 = rand(5, 1000)

# traverse rows

traverse_row_subs(a1, 10)
traverse_row_views(a1, 10)
traverse_row_unsafeviews(a1, 10)

et1 = @elapsed traverse_row_subs(a1, 1000)
et2 = @elapsed traverse_row_views(a1, 1000)
et3 = @elapsed traverse_row_unsafeviews(a1, 1000)

m1 = 1.0 / et1
m2 = 1.0 / et2
m3 = 1.0 / et3

@printf("Traverse Rows:  subs => %7.4f M/sec   views => %7.4f M/sec (%6.3fx)   unsafe_views => %7.4f M/sec (%6.3fx)\n",
    m1, m2, m2 / m1, m3, m3 / m1)

# traverse cols

traverse_column_subs(a2, 10)
traverse_column_views(a2, 10)
traverse_column_unsafeviews(a2, 10)

et1 = @elapsed traverse_column_subs(a2, 1000)
et2 = @elapsed traverse_column_views(a2, 1000)
et3 = @elapsed traverse_column_unsafeviews(a2, 1000)

m1 = 1.0 / et1
m2 = 1.0 / et2
m3 = 1.0 / et3

@printf("Traverse Cols:  subs => %7.4f M/sec   views => %7.4f M/sec (%6.3fx)   unsafe_views => %7.4f M/sec (%6.3fx)\n",
    m1, m2, m2 / m1, m3, m3 / m1)
