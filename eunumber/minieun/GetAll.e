-- Copyright James Cook


ifdef WITHOUT_TRACE then
without trace
end ifdef

include Eun.e
include Common.e
include UserMisc.e
include NanoSleep.e

global function EunCheckAll(sequence s, integer toEun = FALSE)
    -- done.
    Eun test
    sequence config
    integer actualTargetLength, len
    atom radix
    test = s[1] -- type checking.
    config = GetConfiguration1(s[1])
    if toEun then
        s[1] = assign(s[1], 6, config)
    end if
    actualTargetLength = GetActualTargetLength(s[1]) -- actual actualTargetLength, [5] is always negative or zero (0).
    radix = s[1][4]
    for i = 2 to length(s) do
        test = s[i] -- type checking.
        if radix != s[i][4] then
            puts(1, "Error, Eun variables\' radixes aren\'t equal.  Try using ConvertExp().\n")
            abort(1/0)
        end if
        if not equal(config, GetConfiguration1(s[i])) then
            puts(1, "Error, Eun variables\' configurations aren\'t equal.\n")
            abort(1/0)
        end if
        if toEun then
            s[i] = assign(s[i], 6, config)
        end if
        len = GetActualTargetLength(s[i]) -- actual actualTargetLength
        if len > actualTargetLength then -- comparing actual targetLengths
            actualTargetLength = len
        end if
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return {s, actualTargetLength, config}
end function

-- if and_bits(getAllLevel, GET_ALL) then
--     for i = 1 to length(s) do
--         -- [ ] here, look at AdjustRound.e, what should we do for the New format?
--         s[i] = EunGetAllToExp(s[i], TRUE) --, FALSE) -- could possibly be FALSE.
--     end for
-- end if
-- 
-- global function GetAllToExp(sequence n1, integer exp1, integer targetLength, atom radix,
--      integer adjustAccuracy, integer isFull = TRUE, integer moreTargetLen = moreTargetLength)
--     -- done.
--     -- Get all of the precision, and return as a new "Eun".
--     -- Use at the beginning of each "EunFunc1()" function.
--     integer tmp
--     sequence ret
--     if adjustAccuracy < 0 then -- Add, "adjustAccuracy" to "n1", if it exists.
--         if isFull then
--             tmp = moreTargetLen + adjustAccuracy -- adjustAccuracy is always negative, so it basically subtracts from moreTargetLen.
--             if tmp < 1 then
--                 tmp = 1
--             end if
--             targetLength += tmp
--         end if
--         ret = {n1, exp1, targetLength, radix}
--     else
--         ret = {n1, exp1, targetLength + moreTargetLen, radix} -- should execute faster without "adjustAccuracy" value.
--     end if
--     return ret -- returns 4 elements.
-- end function
-- 
-- global function EunGetAllToExp(sequence n1, integer isFull = TRUE) -- n1 shoulde be an "Eun()" datatype.
--     -- done.
--     integer adjustAccuracy
--     sequence config = GetConfiguration1(n1)
--     if length(n1) = 4 then
--         adjustAccuracy = 0
--     else
--         adjustAccuracy = n1[5]
--     end if
--     n1 = GetAllToExp(n1[1], n1[2], n1[3], n1[4], adjustAccuracy, isFull, GetMoreTargetLength1(config))
--     n1 = n1 & {0, config}
--     return n1 -- returns 6 elements.
-- end function
