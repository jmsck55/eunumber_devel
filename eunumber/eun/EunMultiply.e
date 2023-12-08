-- Copyright James Cook

include ../minieun/Multiply.e
include ../minieun/Common.e
include ../minieun/Eun.e
include ../minieun/GetAll.e

-- EunMultiply
global function EunMultiply(sequence n1, sequence n2, integer getAllLevel = NORMAL)
    integer targetLength
    sequence s, config
    s = EunCheckAll({n1, n2})
    config = s[3]
    targetLength = s[2] -- very important
    return MultiplyExp(n1[1], n1[2], n2[1], n2[2], targetLength, n1[4], CARRY_ADJUST, config, getAllLevel)
end function

-- EunSquared
global function EunSquared(sequence n1, integer getAllLevel = NORMAL)
    Eun test = n1
    integer targetLength = GetActualTargetLength(n1)
    sequence config = GetConfiguration1(n1)
    return SquaredExp(n1[1], n1[2], targetLength, n1[4], CARRY_ADJUST, config, getAllLevel)
end function
