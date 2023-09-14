-- Copyright James Cook


include ../../eunumber/minieun/Eun.e
include ../../eunumber/eun/EunMultiplicativeInverse.e

include EunArcSin.e


global function EunArcCsc(Eun a)
    return EunArcSin(EunMultiplicativeInverse(a))
end function
