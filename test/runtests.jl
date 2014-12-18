tests = ["viewtypes",  
         "contrank", 
         "subviews",
         "viewmacro"]

for t in tests
    fp = string(t, ".jl")
    println("* running $fp ...")
    include(fp)
end

