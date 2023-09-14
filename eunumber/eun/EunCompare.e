-- Copyright James Cook

include ../minieun/CompareFuncs.e
include ../minieun/Eun.e

global function EunCompare(Eun n1, Eun n2)
    -- Will not have EunGetAll().  You can use it before calling this function.
    if n1[4] != n2[4] then
        return {}
    end if
    return CompareExp(n1[1], n1[2], n2[1], n2[2])
end function
