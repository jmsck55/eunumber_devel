-- Copyright James Cook


include ../minieun/Eun.e
include ../array/Negate.e


-- EunNegate
global function EunNegate(Eun n1)
    sequence a
    a = EunGetAll(n1)
    a[1] = Negate(a[1])
    a = AdjustRound(a[1], a[2], n1[3], a[4], NO_SUBTRACT_ADJUST)
    return a
end function


-- EunAbsoluteValue
global function EunAbsoluteValue(Eun n1)
    sequence a
    a = EunGetAll(n1)
    a[1] = AbsoluteValue(a[1])
    a = AdjustRound(a[1], a[2], n1[3], a[4], NO_SUBTRACT_ADJUST)
    return a
end function
