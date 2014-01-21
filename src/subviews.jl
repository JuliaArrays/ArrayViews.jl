# subviews of a dense array

# all-colons

view(a::Array, ::Colon) = contiguous_view(a, (length(a),))
