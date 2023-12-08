-- Copyright James Cook

include ../minieun/MultiplicativeInverse.e
include ../minieun/Eun.e
include ../minieun/GetAll.e

-- EunMultiplicativeInverse
global function EunMultiplicativeInverse(sequence n1, sequence guess = {}, integer getAllLevel = NORMAL)
    Eun test = n1
    integer targetLength = GetActualTargetLength(n1)
    sequence config = GetConfiguration1(n1)
    return MultiplicativeInverseExp(n1[1], n1[2], targetLength, n1[4], guess, config, getAllLevel)
end function
