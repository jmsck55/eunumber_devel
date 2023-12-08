-- Copyright James Cook

include ../minieun/Eun.e
include ../minieun/AdjustRound.e
include ../minieun/GetAll.e
include ../array/WholeFracParts.e
include EunDivide.e
include EunMultiply.e
include EunFracIntParts.e
include EunAdjustRound.e

-- Remainder functions:

-- EunModf
global function EunModf(sequence fp, integer getAllLevel = NORMAL)
-- similar to C's "modf()"
    return EunFracIntParts(fp, 3, getAllLevel)
    -- return {EunIntPart(fp, i, getAllLevel), EunFracPart(fp, i, getAllLevel)}
end function

-- EunfDiv
global function EunfDiv(sequence num, sequence den, integer getAllLevel = NORMAL)
-- similar to C's "div()"
    -- returns quotient and remainder
    sequence div
    div = EunModf(EunDivide(num, den, TO_EXP), TO_EXP)
    div[1] = EunAdjustRound(div[1], 0, NO_SUBTRACT_ADJUST, getAllLevel)
    div[2] = EunAdjustRound(EunMultiply(div[2], den, TO_EXP), 0, NO_SUBTRACT_ADJUST, getAllLevel)
    return div
end function

-- EunfMod
global function EunfMod(sequence num, sequence den, integer getAllLevel = NORMAL)
-- similar to C's "fmod()", just the "mod" or remainder
    sequence ret
    ret = EunMultiply(EunFracPart(EunDivide(num, den, TO_EXP), TO_EXP), den, TO_EXP)
    return EunAdjustRound(ret, 0, NO_SUBTRACT_ADJUST, getAllLevel)
end function

-- EunFloorCeil(), EunFloor(), EunCeil()
-- No remainder for Floor and Ceil functions:

global function EunFloorCeil(sequence n1, ThreeOptions floorMode, integer getAllLevel = NORMAL)
    Eun test = n1
    integer targetLength = GetActualTargetLength(n1)
    atom radix = n1[4]
    sequence config = GetConfiguration1(n1)
    n1 = WholeFracParts(n1[1], n1[2], WF_WHOLE_PART, config, floorMode) -- it only returns: {{whole1, exp1}, {frac2, exp2}}
    n1 = n1[WF_WHOLE_PART]
    n1 = AdjustRound(n1[1], n1[2], targetLength, radix, CARRY_ADJUST, config, getAllLevel) -- CARRY_ADJUST, because of "floorMode"
    return n1
end function

global function EunFloor(sequence n1, integer getAllLevel = NORMAL)
    return EunFloorCeil(n1, WF_FLOOR, getAllLevel)
end function

global function EunCeil(sequence n1, integer getAllLevel = NORMAL)
    return EunFloorCeil(n1, WF_CEIL, getAllLevel)
end function
