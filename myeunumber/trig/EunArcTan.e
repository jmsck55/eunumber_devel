-- Copyright James Cook


include ../../eunumber/minieun/Eun.e

include EunArcTanA.e
--include EunArcTanB.e


global function ArcTanExp(sequence n1, integer exp1, integer targetLength, atom radix,
        sequence config = {}, integer getAllLevel = NORMAL)
-- Use the faster, newer method: ArcTanExpA()
    return ArcTanExpA(n1, exp1, targetLength, radix, config, getAllLevel)
end function

global function EunArcTan(Eun a, integer getAllLevel = NORMAL)
    return ArcTanExp(a[1], a[2], a[3], a[4], GetConfiguration1(a), getAllLevel)
end function
