##### Arithmetics on contiguous ranks #####

for m=0:4, n=0:4
    global addrank
    @eval addrank(::Type{ContRank{$m}}, ::Type{ContRank{$n}}) = ContRank{$(m+n)}
end

addrank(::Type{ContRank{M}}, ::Type{ContRank{N}}) where {M,N} = ContRank{M+N}
addrank(::Type{ContRank{0}}, ::Type{ContRank{N}}) where {N} = ContRank{N}
addrank(::Type{ContRank{N}}, ::Type{ContRank{0}}) where {N} = ContRank{N}

for m=0:4, n=0:4
    global minrank
    @eval minrank(::Type{ContRank{$m}}, ::Type{ContRank{$n}}) = ContRank{$(min(m,n))}
end

minrank(::Type{ContRank{M}}, ::Type{ContRank{N}}) where {M,N} = ContRank{min(M,N)}
minrank(::Type{ContRank{0}}, ::Type{ContRank{N}}) where {N} = ContRank{0}
minrank(::Type{ContRank{N}}, ::Type{ContRank{0}}) where {N} = ContRank{0}

for m=0:4, n=0:4
    global restrict_crank
    @eval restrict_crank(::Type{ContRank{$m}}, ::NTuple{$n,Int}) = ContRank{$(min(m,n))}
end

restrict_crank(::Type{ContRank{M}}, ::NTuple{N,Int}) where {M,N} = ContRank{min(M,N)}
restrict_crank(::Type{ContRank{0}}, ::NTuple{N,Int}) where {N} = ContRank{0}
restrict_crank(::Type{ContRank{N}}, ::NTuple{0,Int}) where {N} = ContRank{0}

### contiguous rank computation based on indices

# 0D
contrank() = ContRank{0}

# 1D
contrank(i::Union{Colon,UnitRange}) = ContRank{1}
contrank(i::Subs) = ContRank{0}

# 2D
contrank(i1::Colon, i2::Union{Colon,UnitRange}) = ContRank{2}
contrank(i1::Colon, i2::Subs) = ContRank{1}
contrank(i1::UnitRange, i2::Subs) = ContRank{1}
contrank(i1::Subs, i2::Subs) = ContRank{0}

# 3D
contrank(i1::Colon, i2::Colon, i3::Colon) = ContRank{3}
contrank(i1::Colon, i2::Colon, i3::UnitRange) = ContRank{3}
contrank(i1::Colon, i2::Colon, i3::Subs) = ContRank{2}
contrank(i1::Colon, i2::UnitRange, i3::Subs) = ContRank{2}
contrank(i1::Colon, i2::Subs, i3::Subs) = ContRank{1}
contrank(i1::UnitRange, i2::Subs, i3::Subs) = ContRank{1}
contrank(i1::Subs, i2::Subs, i3::Subs) = ContRank{0}

# ND
contrank(i1::Colon, i2::Colon, i3::Colon, I::Subs...) = addrank(ContRank{3}, contrank(I...))
contrank(i1::Colon, i2::Colon, i3::UnitRange, I::Subs...) = ContRank{3}
contrank(i1::Colon, i2::Colon, i3::Subs, I::Subs...) = ContRank{2}
contrank(i1::Colon, i2::UnitRange, i3::Subs, I::Subs...) = ContRank{2}
contrank(i1::Colon, i2::Subs, i3::Subs, I::Subs...) = ContRank{1}
contrank(i1::UnitRange, i2::Subs, i3::Subs, I::Subs...) = ContRank{1}
contrank(i1::Subs, i2::Subs, i3::Subs, I::Subs...) = ContRank{0}

# contiguous rank with array & arrayviews

acontrank(a::Array, i1::Subs) = contrank(i1)
acontrank(a::Array, i1::Subs, i2::Subs) = contrank(i1, i2)
acontrank(a::Array, i1::Subs, i2::Subs, i3::Subs) = contrank(i1, i2, i3)
acontrank(a::Array, i1::Subs, i2::Subs, i3::Subs, i4::Subs) = contrank(i1, i2, i3, i4)
acontrank(a::Array, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) =
    contrank(i1, i2, i3, i4, i5, I...)

acontrank(a::StridedArrayView{T,N,N}, i1::Subs) where {T,N} = contrank(i1)
acontrank(a::StridedArrayView{T,N,N}, i1::Subs, i2::Subs) where {T,N} = contrank(i1, i2)
acontrank(a::StridedArrayView{T,N,N}, i1::Subs, i2::Subs, i3::Subs) where {T,N} = contrank(i1, i2, i3)
acontrank(a::StridedArrayView{T,N,N}, i1::Subs, i2::Subs, i3::Subs, i4::Subs) where {T,N} =
    contrank(i1, i2, i3, i4)
acontrank(a::StridedArrayView{T,N,N}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) where {T,N} =
    contrank(i1, i2, i3, i4, i5, I...)

acontrank(a::StridedArrayView{T,N,M}, i1::Subs) where {T,N,M} = minrank(contrank(i1), ContRank{M})
acontrank(a::StridedArrayView{T,N,M}, i1::Subs, i2::Subs) where {T,N,M} =
    minrank(contrank(i1, i2), ContRank{M})
acontrank(a::StridedArrayView{T,N,M}, i1::Subs, i2::Subs, i3::Subs) where {T,N,M} =
    minrank(contrank(i1, i2, i3), ContRank{M})
acontrank(a::StridedArrayView{T,N,M}, i1::Subs, i2::Subs, i3::Subs, i4::Subs) where {T,N,M} =
    minrank(contrank(i1, i2, i3, i4), ContRank{M})
acontrank(a::StridedArrayView{T,N,M}, i1::Subs, i2::Subs, i3::Subs, i4::Subs, i5::Subs, I::Subs...) where {T,N,M} =
    minrank(contrank(i1, i2, i3, i4, i5, I...), ContRank{M})
