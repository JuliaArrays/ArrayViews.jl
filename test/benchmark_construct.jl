# Benchmark on view construction (overhead)

using ArrayViews

function traverse_row_subs(a::Array)
    m = size(a, 1)
    for i = 1:m
        sub(a, i, :)
    end
end

function traverse_row_views(a::Array)
    m = size(a, 1)
    for i = 1:m
        view(a, i, :)
    end
end

function traverse_column_subs(a::Array)
    n = size(a, 2)
    for i = 1:n
        sub(a, :, i)
    end
end

function traverse_column_views(a::Array)
    n = size(a, 2)
    for i = 1:n
        view(a, :, i)
    end
end

function traverse_page_subs(a::Array)
    n = size(a, 3)
    for i = 1:n
        sub(a, :, :, i)
    end
end

function traverse_page_views(a::Array)
    n = size(a, 3)
    for i = 1:n
        view(a, :, :, i)
    end
end

## data

const a1 = rand(1000, 5)
const a2 = rand(5, 1000)
const a3 = rand(2, 3, 1000)

# traverse rows

traverse_row_subs(a1)
traverse_row_views(a1)

et1 = @elapsed for t = 1:1000; traverse_row_subs(a1); end
et2 = @elapsed for t = 1:1000; traverse_row_views(a1); end

@printf("Traverse Rows:  subs => %7.4f sec    views => %7.4f sec  |  gain = %6.3fx\n", et1, et2, et1 / et2)

# traverse cols

traverse_column_subs(a2)
traverse_column_views(a2)

et1 = @elapsed for t = 1:1000; traverse_column_subs(a2); end
et2 = @elapsed for t = 1:1000; traverse_column_views(a2); end

@printf("Traverse Cols:  subs => %7.4f sec    views => %7.4f sec  |  gain = %6.3fx\n", et1, et2, et1 / et2)

# traverse pages

traverse_page_subs(a3)
traverse_page_views(a3)

et1 = @elapsed for t = 1:1000; traverse_page_subs(a3); end
et2 = @elapsed for t = 1:1000; traverse_page_views(a3); end

@printf("Traverse Pages: subs => %7.4f sec    views => %7.4f sec  |  gain = %6.3fx\n", et1, et2, et1 / et2)


