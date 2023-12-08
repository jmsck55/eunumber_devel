-- Copyright James Cook

include ../array/WholeFracParts.e
include ../minieun/Eun.e
include ../minieun/Defaults.e
include ../minieun/AdjustRound.e

global function EunFracIntParts(sequence n1, integer mode, integer getAllLevel = NORMAL)
    Eun test = n1
    integer targetLength = GetActualTargetLength(n1)
    atom radix = n1[4]
    sequence config = GetConfiguration1(n1)
    n1 = WholeFracParts(n1[1], n1[2], mode, config)
    if and_bits(mode, 1) then
        n1[1] = AdjustRound(n1[1][1], n1[1][2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
    end if
    if and_bits(mode, 2) then
        n1[2] = AdjustRound(n1[2][1], n1[2][2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
    end if
    if mode = 3 then
        return n1
    else
        return n1[mode]
    end if
end function

-- EunFracPart
global function EunFracPart(sequence n1, integer getAllLevel = NORMAL)
    return EunFracIntParts(n1, WF_FRAC_PART, getAllLevel)
end function

-- EunIntPart
global function EunIntPart(sequence n1, integer getAllLevel = NORMAL)
    return EunFracIntParts(n1, WF_WHOLE_PART, getAllLevel)
end function

-- global function EunFracPart(Eun n1, integer intModeFloat = integerModeFloat)
--     integer len
--     if n1[2] >= 0 then
--         len = n1[2] + 1
-- if ROUND_TO_NEAREST_OPTION then
--         len += intModeFloat
-- end if
--         if len >= length(n1[1]) then
--             n1[1] = {}
--             n1[2] = 0
--         else
--             n1[1] = n1[1][len + 1..$]
--             n1[2] = -1
-- if ROUND_TO_NEAREST_OPTION then
--             n1[2] -= (intModeFloat)
-- end if
--             n1 = EunAdjustRound(n1)
--         end if
--     end if
--     return n1
-- end function

-- global function EunIntPart(Eun n1, integer intModeFloat = integerModeFloat)
--     integer len
--     len = n1[2] + 1
-- if ROUND_TO_NEAREST_OPTION then
--     len += intModeFloat
-- end if
--     if len < length(n1[1]) then
--         if n1[2] < 0 then
--             n1[1] = {}
--             n1[2] = 0
--         else
--             n1[1] = n1[1][1..len]
--             n1 = EunAdjustRound(n1)
--         end if
--     end if
--     return n1
-- end function
