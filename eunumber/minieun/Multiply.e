-- Copyright James Cook
-- Multiply functions of EuNumber.

namespace multiply

ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../array/Mult.e
include Eun.e
include Common.e
include Defaults.e
include AdjustRound.e

global function MultiplyExp(sequence n1, integer exp1, sequence n2, integer exp2, integer targetLength, atom radix,
        integer isMixed = CARRY_ADJUST, sequence config = {}, integer getAllLevel = NORMAL)
    sequence numArray, ret
    numArray = Multiply(n1, n2, {targetLength, radix}, GetMultMoreAccuracy1(config))
    if isMixed = AUTO_ADJUST then
        isMixed = CARRY_ADJUST -- it will use "carry()"
    end if
    ret = AdjustRound(numArray, exp1 + exp2, targetLength, radix, isMixed, config, getAllLevel)
    return ret
end function

global function SquaredExp(sequence n1, integer exp1, integer targetLength, atom radix,
        integer isMixed = CARRY_ADJUST, sequence config = {}, integer getAllLevel = NORMAL)
    return MultiplyExp(n1, exp1, n1, exp1, targetLength, radix, isMixed, config, getAllLevel)
end function

--     integer isIntegerMode, intModeFloat, moreTargetLen, newMinLength, exponent
--     if length(config) then
--         isIntegerMode = GetIsIntegerMode1(config)
--         intModeFloat = GetIntegerModeFloat1(config)
--         moreTargetLen = GetMoreTargetLength1(config)
--     else
--         isIntegerMode = ROUND_TO_NEAREST_OPTION -- otherwise this should be FALSE
--         intModeFloat = integerModeFloat -- otherwise this should be zero (0).
--         moreTargetLen = moreTargetLength
--     end if
--     exponent = exp1 + exp2
--     if isIntegerMode then
--         newMinLength = exponent + 1 + intModeFloat
--     else
--         newMinLength = targetLength
--     end if
--     newMinLength += 3 -- moreTargetLen -- Uses new "moreTargetLength" library internal, which is usually two (2).
--     newMinLength = min(newMinLength, length(n1) + length(n2) - 1)
--
-- -- Three Multiply methods:
-- 
-- ifdef not MULTIPLY_LOW_POWER then
-- with define MULTIPLY_OLDER
-- end ifdef
-- 
-- --    MULTIPLY_POWER_HUNGRY = 0, -- legacy, uses brute force method, consumes the most energy or power.
-- --    MULTIPLY_OLDER = 1, -- works for most processors.
-- --    MULTIPLY_LOW_POWER = 2 -- You can try this one on new computers.
-- 
-- ifdef MULTIPLY_POWER_HUNGRY then
-- 
-- global function Multiply(sequence n1, sequence n2)
--     integer f
--     sequence numArray
--     if length(n1) = 0 or length(n2) = 0 then
--         return {}
--     end if
-- -- This method may be faster:
--     numArray = repeat(0, length(n1) + length(n2) - 1)
--     for i = 1 to length(n1) do
--         f = i
--         for h = 1 to length(n2) do
--             numArray[f] += n1[i] * n2[h]
--             f += 1
-- ifdef not NO_SLEEP_OPTION then
--             sleep(nanoSleep)
-- end ifdef
--         end for
-- ifdef not NO_SLEEP_OPTION then
--         sleep(nanoSleep)
-- end ifdef
--     end for
--     return numArray
-- end function
-- 
-- end ifdef
-- 
-- ifdef MULTIPLY_OLDER then
-- 
-- global function Multiply(sequence n1, sequence n2, integer minLen = length(n1) + length(n2) - 1)
--     integer f, j
--     atom g, e
--     sequence numArray
--     if minLen <= 0 or length(n1) = 0 or length(n2) = 0 then
--         return {}
--     end if
--     -- minLen = length(n1) + length(n2) - 1 -- minLen is set by the function call.
--     numArray = repeat(0, minLen)
--     f = length(n2)
--     for i = 1 to length(n1) do
--         g = n1[i]
--         if g then
--             j = 1
--             for h = i to min(minLen, f) do
--                 e = n2[j]
--                 if e then
--                     e *= g
--                     numArray[h] += e
--                 end if
--                 j += 1
-- ifdef not NO_SLEEP_OPTION then
--                 sleep(nanoSleep)
-- end ifdef
--             end for
--         end if
--         f += 1
-- ifdef not NO_SLEEP_OPTION then
--         sleep(nanoSleep)
-- end ifdef
--     end for
--     return numArray
-- end function
-- 
-- end ifdef
-- 
-- ifdef MULTIPLY_LOW_POWER then
-- 
-- global function Multiply(sequence n1, sequence n2, integer minLen = length(n1) + length(n2) - 1)
--     integer f, j
--     atom g
--     sequence numArray
--     if minLen <= 0 or length(n1) = 0 or length(n2) = 0 then
--         return {}
--     end if
--     -- minLen = length(n1) + length(n2) - 1 -- minLen is set by the function call.
--     numArray = repeat(0, minLen)
--     f = 1
--     if minLen > length(n2) then
--         for k = length(n2) to minLen do
--         -- for i = 1 to length(n1) do
--             g = n1[f]
--             j = 1
--             -- k = iff(minLen < f1, minLen, f1)
--             for h = f to k do
--                 numArray[h] += g * n2[j]
--                 j += 1
-- ifdef not NO_SLEEP_OPTION then
--                 sleep(nanoSleep)
-- end ifdef
--             end for
--             f += 1
-- ifdef not NO_SLEEP_OPTION then
--             sleep(nanoSleep)
-- end ifdef
--         end for
--     end if
--     for i = f to length(n1) do
--         g = n1[i]
--         j = 1
--         -- k = iff(minLen < f1, minLen, f1)
--         for h = i to minLen do
--             numArray[h] += g * n2[j]
--             j += 1
-- ifdef not NO_SLEEP_OPTION then
--             sleep(nanoSleep)
-- end ifdef
--         end for
--         f += 1
-- ifdef not NO_SLEEP_OPTION then
--         sleep(nanoSleep)
-- end ifdef
--     end for
--     return numArray
-- end function
-- 
-- end ifdef
-- 
-- global function Squared(sequence n1)
--     return Multiply(n1, n1) -- multiply it by its self, once
-- end function

