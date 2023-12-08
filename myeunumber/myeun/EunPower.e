-- Copyright James Cook

include ../../eunumber/eun/EunMultiply.e
include ../../eunumber/minieun/AdjustRound.e
include ../../eunumber/minieun/Eun.e
include ../../eunumber/minieun/GetAll.e
include EunExp.e
include EunLog.e

-- Powers: a number (base), raised to the power of another number (raisedTo)

global function EunPower(sequence base, sequence raisedTo, integer getAllLevel = NORMAL)
-- b^x = e^(x * ln(b))
    integer targetLength
    sequence s, config
    s = EunCheckAll({base, raisedTo}, 1) -- 1 for: toEun = TRUE
    config = s[3]
    targetLength = s[2]
    s = s[1]
    base = s[1]
    raisedTo = s[2]
    s = EunExp(EunMultiply(EunLog(base, TO_EXP), raisedTo, TO_EXP), TO_EXP)
    return AdjustRound(s[1], s[2], targetLength, s[4], NO_SUBTRACT_ADJUST, config, getAllLevel)
end function
