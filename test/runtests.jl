tests = ["arrviews",
         "contrank",
         "subviews",
         "linalg",
         "convenience"]

for t in tests
    fp = string(t, ".jl")
    println("* running $fp ...")
    include(fp)
end
