-- Copyright James Cook

include ../minieun/Eun.e
include ../minieun/Reverse.e

-- EunReverse
global function EunReverse(Eun n1) -- reverse endian
    sequence a
    a = EunGetAll(n1)
    a[3] = n1[3]
    a[1] = reverse(a[1])
    return a
end function
