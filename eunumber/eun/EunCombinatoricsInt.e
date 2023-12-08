-- Copyright James Cook

include ../minieun/Eun.e
include ../minieun/Defaults.e
include ../minieun/AddExp.e
include ../minieun/GetAll.e

include EunAdjustRound.e
include EunFracIntParts.e

global type UpOneRange(integer i)
    return i <= 1 and i >= -1
end type

global function EunCombInt(sequence ret, integer adjustBy = 0, UpOneRange upOne = 0, integer getAllLevel = NORMAL) -- upOne should be: 1, 0, or -1
-- if there is any fraction part, add or subtract one, away from zero,
-- or ceil, if upOne == 1, add one towards positive infinity, if "up = 1"
-- or floor, if upOne == -1, add one towards negative infinity, if "up = -1"
-- done.
    Eun test = ret -- used below.
    integer len, exponent, targetLength, intModeFloat
    intModeFloat = GetIntegerModeFloat1(ret)
    targetLength = GetActualTargetLength(ret) + adjustBy
    len = length(ret[1])
    if len then -- if len > 0 then
        exponent = ret[2] + intModeFloat
        ret = EunIntPart(ret, NORMAL) -- needs to be NORMAL, nothing extra on the end.
        if (exponent < 0) or (exponent + 1 < len) then
            -- add one, same sign
            if upOne = 0 then
                if test[1][1] < 0 then
                    upOne = -1
                else
                    upOne = 1
                end if
            end if
            return AddExp(ret[1], ret[2], {upOne}, - (intModeFloat), ret[3], ret[4], AUTO_ADJUST, GetConfiguration1(ret), getAllLevel)
        end if
    end if
    return AdjustRound(ret[1], ret[2], targetLength, ret[4], NO_SUBTRACT_ADJUST, GetConfiguration1(ret), getAllLevel)
end function

global function EunCombinatoricsInt(sequence ret, integer adjustBy = 0, UpOneRange upOne = 0, integer getAllLevel = NORMAL) -- upOne should be: 1, 0, or -1
    return EunCombInt(ret, adjustBy, upOne, getAllLevel)
end function
