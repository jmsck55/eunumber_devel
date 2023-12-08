-- Copyright James Cook

include ../../eunumber/minieun/Eun.e
include ../../eunumber/eun/EunMultiplicativeInverse.e
include EunPower.e

global function EunGeneralRoot(Eun rooted, Eun anyNumber, integer getAllLevel = NORMAL)
    integer firstFlag = and_bits(getAllLevel, GET_ALL)
    integer lastFlag = and_bits(getAllLevel, TO_EXP)
    object tmp
    tmp = EunPower(rooted, EunMultiplicativeInverse(anyNumber, {}, firstFlag), lastFlag + GET_ALL)
    return tmp
end function
