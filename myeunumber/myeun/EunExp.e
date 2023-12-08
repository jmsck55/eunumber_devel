-- Copyright James Cook


--NOTE: EunExp() functions are "a work in progress".

include ../../eunumber/minieun/Eun.e
include ../../eunumber/minieun/Common.e
--include ../../eunumber/array/WholeFracParts.e
include ../../eunumber/eun/EunMultiply.e
--include AdjustPrecision.e
include GetE.e
include EunExpWhole.e
include ExpExp.e

global Bool expIsFactor = 0

global procedure SetExpIsFactor(integer i = TRUE)
    expIsFactor = i
end procedure

global function GetExpIsFactor()
    return expIsFactor
end function

global function EunExp(sequence num, integer getAllLevel = NORMAL)
--
-- ExpExp() doesn't like large numbers.
-- so, x = 1/x; x = exp^x; x = 1/x; return x;
--
--      e^(a + b) <=> e^(a) * e^(b)
--      e^(whole + frac) <=> EunExpWhole(E, whole) * EunExp(fract)
--
    -- get the whole and fractional parts of the number:
    sequence frac, config
    integer size, targetLength
    Eun test = num
    size = num[2] + 1
    targetLength = GetActualTargetLength(num)
    config = GetConfiguration1(num)
    -- factor out (-1), use MultiplicativeInverse (1/x) later
    --isNeg = IsNegative(num[1])
    --if isNeg then -- Take the absolute value of the number, while saving isNeg.
    --    num[1] = Negate(num[1])
    --end if
    frac = num
    if size > 0 then
        if size < length(num[1]) then
            frac[1] = num[1][size + 1..$] -- copy this first.
            frac[2] = -1
            num[1] = num[1][1..size] -- then subscript this.
        else
            frac = {}
        end if
        --num[3] += adjustPrecision
        num = EunExpWhole(GetE(targetLength, num[4], config, TO_EXP), num, TO_EXP)
        --num[3] -= adjustPrecision
    else
        num = {}
    end if
    if length(frac) then
        frac = ExpExp(frac[1], frac[2], targetLength, frac[4], expIsFactor, config, TO_EXP)
        if length(num) then
            num = EunMultiply(num, frac, TO_EXP)
        else
            num = frac
        end if
    end if
    --if isNeg then
    --    num = EunMultiplicativeInverse(num)
    --end if
    num = AdjustRound(num[1], num[2], targetLength, num[4], NO_SUBTRACT_ADJUST, config, getAllLevel)
    return num
end function
--here:
global constant eunExpRID = routine_id("EunExp")


include ExpCommon.e


global function EunExpC(Eun x)
    return EunExpId(eunExpRID, x)
end function

