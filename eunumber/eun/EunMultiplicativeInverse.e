-- Copyright James Cook

include ../minieun/MultiplicativeInverse.e
include ../minieun/Eun.e

-- EunMultiplicativeInverse
global function EunMultiplicativeInverse(Eun n1, sequence guess = {})
    sequence a
    a = EunGetAll(n1)
    return MultiplicativeInverseExp(a[1], a[2], n1[3], a[4], guess)
end function
