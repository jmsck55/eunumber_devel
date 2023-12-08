-- Copyright James Cook

include ../minieun/Eun.e
include ../minieun/AdjustRound.e
include ../minieun/GetAll.e

-- EunAdjustRound
global function EunAdjustRound(sequence n1, integer adjustBy = 0, integer isMixed = NO_SUBTRACT_ADJUST, integer getAllLevel = NORMAL)
    Eun test = n1
    sequence config = GetConfiguration1(n1)
    integer len
    len = GetActualTargetLength(n1)
    len += adjustBy
    n1 = AdjustRound(n1[1], n1[2], len, n1[4], isMixed, config, getAllLevel)
    return n1
end function
