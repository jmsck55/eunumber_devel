-- Copyright James Cook

include ../minieun/Divide.e
include ../minieun/Common.e
include ../minieun/UserMisc.e
include ../minieun/Eun.e

-- EunDivide
global function EunDivide(Eun n1, Eun n2)
    TargetLength targetLength
    sequence a1, a2
    if n1[4] != n2[4] then
        printf(1, "Error %d\n", 5)
        abort(1/0)
    end if
    targetLength = max(n1[3], n2[3])
    a1 = EunGetAll(n1)
    a2 = EunGetAll(n2)
    return DivideExp(a1[1], a1[2], a2[1], a2[2], targetLength, a1[4])
end function
