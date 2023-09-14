-- Copyright James Cook


include ../../eunumber/minieun/Eun.e
include ../../eunumber/eun/EunMultiplicativeInverse.e

include EunArcCos.e


global function EunArcSec(Eun a)
    return EunArcCos(EunMultiplicativeInverse(a))
end function
