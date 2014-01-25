tests = ["contiguousview", 
         "stridedview", 
         "linalg", 
         "contrank", 
         "subviews", 
         "subviews2"]

for t in tests
    fp = joinpath("test", "$(t).jl")
    println("* running $fp ...")
    include(fp)
end

