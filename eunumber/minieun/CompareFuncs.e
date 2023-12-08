-- Copyright James Cook
-- "Compare" and "Equal" functions of EuNumber.

ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../array/TrimZeros.e
include Common.e
include NanoSleep.e
include UserMisc.e
include MultiTasking.e

-- EunCompare:

global function CompareExpLen(sequence n1, integer exp1, sequence n2, integer exp2, integer minlen = -1, PositiveInteger compareStart = 1)
-- It doesn't look at targetLength or radix, so both "targetLength" and "radix" should be the same.
-- Fixed.
    integer f, equalLen = 0, compareMinLen = 0
    n1 = TrimTrailingZeros(n1) -- keep these.
    n2 = TrimTrailingZeros(n2) -- keep these.
    -- Case of zero (0)
    if length(n1) = 0 then
        if length(n2) = 0 then
            return {0, 0, 0}
        end if
        if n2[1] < 0 then
            return {1, 0, 0}
        else
            return {-1, 0, 0}
        end if
        -- return iff(n2[1] < 0, 1, -1)
    end if
    if length(n2) = 0 then
        if n1[1] > 0 then
            return {1, 0, 0}
        else
            return {-1, 0, 0}
        end if
        -- return iff(n1[1] > 0, 1, -1)
    end if
    -- Case of unequal signs (mismatch of signs, sign(n1) xor sign(n2))
    if PositiveDigit(n1[1]) then -- if IsPositive(n1) then
        if NegativeDigit(n2[1]) then -- if IsNegative(n2) then
            return {1, 0, 0}
        end if
        -- both positive
        if exp1 != exp2 then
            if exp1 > exp2 then
                return {1, 0, 0}
            else
                return {-1, 0, 0}
            end if
            -- return iff(exp1 > exp2, 1, -1)
            -- return (exp1 > exp2) - (exp1 < exp2)
        end if
    else -- if IsNegative(n1) then
        if PositiveDigit(n2[1]) then -- if IsPositive(n2) then
            return {-1, 0, 0}
        end if
        -- both negative
        if exp1 != exp2 then
            if exp1 < exp2 then
                return {1, 0, 0}
            else
                return {-1, 0, 0}
            end if
            -- return iff(exp1 < exp2, 1, -1)
            -- return (exp1 < exp2) - (exp1 > exp2)
        end if
    end if
    -- exponents and signs are the same:
    f = (minlen >= 0)
    if not f then
        minlen = min(length(n1), length(n2))
    end if
    compareMinLen = minlen
    for i = compareStart to minlen do
        if n1[i] != n2[i] then
            if n1[i] > n2[i] then
                return {1, equalLen, compareMinLen}
            else
                return {-1, equalLen, compareMinLen}
            end if
            -- return iff(n1[i] > n2[i], 1, -1)
        end if
        equalLen += 1
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    if f or length(n1) = length(n2) then
        return {0, equalLen, compareMinLen}
    end if
    if NegativeDigit(n1[1]) then -- if IsNegative(n1) then
        if length(n1) > length(n2) then
            return {-1, equalLen, compareMinLen}
        else
            return {1, equalLen, compareMinLen}
        end if
        -- return iff(length(n1) > length(n2), -1, 1)
    else -- if IsPositive(n1) then
        if length(n1) > length(n2) then
            return {1, equalLen, compareMinLen}
        else
            return {-1, equalLen, compareMinLen}
        end if
        -- return iff(length(n1) > length(n2), 1, -1)
    end if
end function

integer equalLength = 0
integer compareMinLength = 0

global function GetEqualLength() -- get equalLength of the last CompareExp(), or EunCompare()
    return equalLength
end function

global function GetCompareMin()
    return compareMinLength
end function

global function CompareExp(sequence n1, integer exp1, sequence n2, integer exp2, integer minlen = -1, integer compareStart = 1)
    object x
    x = CompareExpLen(n1, exp1, n2, exp2, minlen, compareStart)
    equalLength = x[2]
    compareMinLength = x[3]
    return x[1]
end function


-- RangeEqual() and Equaln()

global function RangeEqual(sequence a, sequence b, PositiveInteger start, PositiveInteger stop)
ifdef USE_TASK_YIELD then
    if useTaskYield then
        task_yield()
    end if
end ifdef
    if length(a) >= stop and length(b) >= stop then
        for i = stop to start by -1 do
            if a[i] != b[i] then
                return 0
            end if
ifdef not NO_SLEEP_OPTION then
            sleep(nanoSleep)
end ifdef
        end for
        return 1
    end if
    return 0
end function

global function Equaln(sequence a, sequence b, PositiveInteger lastMinLen = 0, integer stop = -1)
    integer minlen, maxlen
ifdef USE_TASK_YIELD then
    if useTaskYield then
        task_yield()
    end if
end ifdef
    -- start = lastMinLen + 1 -- lastMinLen has to be zero (0) or greater.
    if length(a) > length(b) then
        maxlen = length(a)
        minlen = length(b)
    else
        maxlen = length(b)
        minlen = length(a)
    end if

    if stop > minlen or stop < 0 then
        stop = minlen
    end if

    if lastMinLen > minlen then
        lastMinLen = 0 -- if start is too big, start back at 1
    end if
    for i = lastMinLen + 1 to stop do
        if a[i] != b[i] then
            lastMinLen = i - 1
            return {lastMinLen, maxlen}
        end if
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    if lastMinLen and not RangeEqual(a, b, 1, lastMinLen) then
        return Equaln(a, b)
    end if
    lastMinLen = minlen
    return {lastMinLen, maxlen}
end function
