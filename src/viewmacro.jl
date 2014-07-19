#fixend replaces symbol("end") in an index with length(objname) if d==0
#or size(objname, d) for d > 0
fixend(arg::Symbol, objnam::Symbol, d::Int) =
    if arg == symbol("end")
        if d == 0
            :(length($objnam))
        else
             :(size($objnam, $d))
        end
    else
        arg
    end
function fixend(arg::Expr, objnam::Symbol, d::Int)
    #if this expr is another :ref, then any symbol("end")s in subexpressions refer to this :ref,
    # so return
    arg.head == :ref && return arg
    #check for the special case :(1:end) and convert that to :(:)
    arg == :(1:$(symbol("end"))) && return :(:)
    #otherwise fix any ends in the args
    map!(a -> fixend(a, objnam, d), arg.args)
    arg
end
fixend(arg, objnam::Symbol, d::Int) =  arg

macro view(ex)
    isa(ex, Symbol) && return :(view($(esc(ex))))
    isa(ex, Expr) && ex.head == :ref && isa(ex.args[1], Symbol) ||
        error("@view accepts a named object or indexed named object (e.g. A(I_1, I_2,...,I_n))")
    objnam = ex.args[1]

    if length(ex.args) == 2
        ex.args[2] = fixend(ex.args[2], objnam, 0)
    else
        for (d, arg) in enumerate(ex.args[2:end])
            ex.args[d+1] = fixend(arg, objnam, d)
        end
    end
    :(view($(map(esc, ex.args)...)))
end
