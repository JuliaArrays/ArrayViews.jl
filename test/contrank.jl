# contrank arithmetics

using ArrayViews
using Base.Test
import ArrayViews: Subs, ContRank, contrank

const irealn = 3
const icolon = (:)
const irange = 1:5
const istepr = 1:2:5

crank{M}(::Type{ContRank{M}}) = M
crank(I::Subs...) = crank(contrank(I...))


@test crank() == 0

# 1D

@test crank(irealn) == 1
@test crank(icolon) == 1
@test crank(irange) == 1
@test crank(istepr) == 0

# 2D

@test crank(irealn, irealn) == 2
@test crank(irealn, icolon) == 1
@test crank(irealn, irange) == 1
@test crank(irealn, istepr) == 1

@test crank(icolon, irealn) == 2
@test crank(icolon, icolon) == 2
@test crank(icolon, irange) == 2
@test crank(icolon, istepr) == 1

@test crank(irange, irealn) == 2
@test crank(irange, icolon) == 1
@test crank(irange, irange) == 1
@test crank(irange, istepr) == 1

@test crank(istepr, irealn) == 0
@test crank(istepr, icolon) == 0
@test crank(istepr, irange) == 0
@test crank(istepr, istepr) == 0

# 3D

@test crank(irealn, irealn, irealn) == 3
@test crank(irealn, irealn, icolon) == 2
@test crank(irealn, irealn, irange) == 2
@test crank(irealn, irealn, istepr) == 2

@test crank(irealn, icolon, irealn) == 1
@test crank(irealn, icolon, icolon) == 1
@test crank(irealn, icolon, irange) == 1
@test crank(irealn, icolon, istepr) == 1

@test crank(irealn, irange, irealn) == 1
@test crank(irealn, irange, icolon) == 1
@test crank(irealn, irange, irange) == 1
@test crank(irealn, irange, istepr) == 1

@test crank(irealn, istepr, irealn) == 1
@test crank(irealn, istepr, icolon) == 1
@test crank(irealn, istepr, irange) == 1
@test crank(irealn, istepr, istepr) == 1

@test crank(icolon, irealn, irealn) == 3
@test crank(icolon, irealn, icolon) == 2
@test crank(icolon, irealn, irange) == 2
@test crank(icolon, irealn, istepr) == 2

@test crank(icolon, icolon, irealn) == 3
@test crank(icolon, icolon, icolon) == 3
@test crank(icolon, icolon, irange) == 3
@test crank(icolon, icolon, istepr) == 2

@test crank(icolon, irange, irealn) == 3
@test crank(icolon, irange, icolon) == 2
@test crank(icolon, irange, irange) == 2
@test crank(icolon, irange, istepr) == 2

@test crank(icolon, istepr, irealn) == 1
@test crank(icolon, istepr, icolon) == 1
@test crank(icolon, istepr, irange) == 1
@test crank(icolon, istepr, istepr) == 1

@test crank(irange, irealn, irealn) == 3
@test crank(irange, irealn, icolon) == 2
@test crank(irange, irealn, irange) == 2
@test crank(irange, irealn, istepr) == 2

@test crank(irange, icolon, irealn) == 1
@test crank(irange, icolon, icolon) == 1
@test crank(irange, icolon, irange) == 1
@test crank(irange, icolon, istepr) == 1

@test crank(irange, irange, irealn) == 1
@test crank(irange, irange, icolon) == 1
@test crank(irange, irange, irange) == 1
@test crank(irange, irange, istepr) == 1

@test crank(irange, istepr, irealn) == 1
@test crank(irange, istepr, icolon) == 1
@test crank(irange, istepr, irange) == 1
@test crank(irange, istepr, istepr) == 1

@test crank(istepr, irealn, irealn) == 0
@test crank(istepr, irealn, icolon) == 0
@test crank(istepr, irealn, irange) == 0
@test crank(istepr, irealn, istepr) == 0

@test crank(istepr, icolon, irealn) == 0
@test crank(istepr, icolon, icolon) == 0
@test crank(istepr, icolon, irange) == 0
@test crank(istepr, icolon, istepr) == 0

@test crank(istepr, irange, irealn) == 0
@test crank(istepr, irange, icolon) == 0
@test crank(istepr, irange, irange) == 0
@test crank(istepr, irange, istepr) == 0

@test crank(istepr, istepr, irealn) == 0
@test crank(istepr, istepr, icolon) == 0
@test crank(istepr, istepr, irange) == 0
@test crank(istepr, istepr, istepr) == 0

# Some 4D

@test crank(icolon, icolon, irealn, irealn) == 4
@test crank(icolon, icolon, irealn, icolon) == 3
@test crank(icolon, icolon, irealn, irange) == 3
@test crank(icolon, icolon, irealn, istepr) == 3

@test crank(icolon, icolon, icolon, irealn) == 4
@test crank(icolon, icolon, icolon, icolon) == 4
@test crank(icolon, icolon, icolon, irange) == 4
@test crank(icolon, icolon, icolon, istepr) == 3

@test crank(icolon, icolon, irange, irealn) == 4
@test crank(icolon, icolon, irange, icolon) == 3
@test crank(icolon, icolon, irange, irange) == 3
@test crank(icolon, icolon, irange, istepr) == 3

@test crank(icolon, icolon, istepr, irealn) == 2
@test crank(icolon, icolon, istepr, icolon) == 2
@test crank(icolon, icolon, istepr, irange) == 2
@test crank(icolon, icolon, istepr, istepr) == 2

# Some 5D

@test crank(icolon, icolon, icolon, icolon, irealn) == 5

