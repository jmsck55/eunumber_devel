-- Copyright James Cook

include ../minieun/Eun.e
include ../minieun/GetAll.e
include ../minieun/AdjustRound.e
include ../array/Negate.e

-- EunNegate
global function EunNegate(sequence n1, integer getAllLevel = NORMAL)
    Eun test = n1
    sequence config = GetConfiguration1(n1)
    integer targetLength = GetActualTargetLength(n1)
    n1[1] = Negate(n1[1])
    n1 = AdjustRound(n1[1], n1[2], targetLength, n1[4], NO_SUBTRACT_ADJUST, config, getAllLevel)
    return n1
end function

-- EunAbsoluteValue
global function EunAbsoluteValue(sequence n1, integer getAllLevel = NORMAL)
    Eun test = n1
    sequence config = GetConfiguration1(n1)
    integer targetLength = GetActualTargetLength(n1)
    n1[1] = AbsoluteValue(n1[1])
    n1 = AdjustRound(n1[1], n1[2], targetLength, n1[4], NO_SUBTRACT_ADJUST, config, getAllLevel)
    return n1
end function
