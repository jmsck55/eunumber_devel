-- Copyright James Cook

-- ExpFast() isn't accurate on large exponents.
-- It seems to work for the fourth (4th) spatial dimension.

include ../../eunumber/minieun/nanosleep.e
include ../../eunumber/minieun/common.e
include ../../eunumber/minieun/AddExp.e
include ../../eunumber/minieun/Multiply.e
include ../../eunumber/minieun/Divide.e
include ../../eunumber/minieun/Eun.e
include ../../eunumber/minieun/returntouser.e
include ../../eunumber/minieun/AdjustRound.e
include ../../eunumber/minieun/FindIter.e
--include EunExp.e

global PositiveScalar expFastIter = 4 -- try to keep this number small, but greater or equal to 4.
global PositiveScalar expFastIterMax = 1024
global PositiveInteger expFastHalf = 0
global PositiveInteger expFastConfidence = 0

procedure ExpFindIter(integer i)
    sequence s = FindIter(i, {expFastIter, expFastHalf, expFastConfidence}, 4, expFastIterMax)
    expFastIter = s[1]
    expFastHalf = s[2]
    expFastConfidence = s[3]
end procedure

global function GetExpFastIter()
    return expFastIter
end function

global procedure SetExpFastIter(integer i) -- when switching radixes, store expFastIter, switch, and then call SetExpFastIter() when you switch back.
    expFastIter = i
end procedure

global sequence expFastHowComplete = {1, 0}

global function GetExpFastHowCompleteMin()
    return expFastHowComplete[1]
end function

global function GetExpFastHowCompleteMax()
    return expFastHowComplete[2]
end function

global constant ID_ExpFast = 5

global function ExpFast(sequence x1, integer exp1, sequence y2, integer exp2, integer targetLength, atom radix, PositiveScalar theExpFastIter)
-- e^(x/y) = 1 + 2x/(2y-x+x^2/(6y+x^2/(10y+x^2/(14y+x^2/(18y+x^2/(22y+...
    -- precalculate:
    -- 1, 2x, x, x^2, 4y, (2 + 4i)y
    -- i = targetLength to 0.
    -- Subtract 4y
    sequence xSquared, fourY, targetLengthY, tmp, s
    expFastHowComplete = {1, 0}
    xSquared = SquaredExp(x1, exp1, targetLength, radix)
    fourY = MultiplyExp({-4}, 0, y2, exp2, targetLength, radix)
    s = AdjustRound({2 + 4 * theExpFastIter}, 0, targetLength, radix, FALSE)
    targetLengthY = MultiplyExp(s[1], s[2], y2, exp2, targetLength, radix)
    tmp = targetLengthY
    for i = theExpFastIter to 2 by -1 do
        tmp = DivideExp(xSquared[1], xSquared[2], tmp[1], tmp[2], targetLength, radix)
        targetLengthY = AddExp(targetLengthY[1], targetLengthY[2], fourY[1], fourY[2], targetLength, radix)
        tmp = AddExp(tmp[1], tmp[2], targetLengthY[1], targetLengthY[2], targetLength, radix)
        expFastHowComplete[1] = i
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    tmp = DivideExp(xSquared[1], xSquared[2], tmp[1], tmp[2], targetLength, radix)
    tmp = SubtractExp(tmp[1], tmp[2], x1, exp1, targetLength, radix)
    s = MultiplyExp(y2, exp2, {2}, 0, targetLength, radix)
    tmp = AddExp(tmp[1], tmp[2], s[1], s[2], targetLength, radix)
    s = MultiplyExp(x1, exp1, {2}, 0, targetLength, radix)
    tmp = DivideExp(s[1], s[2], tmp[1], tmp[2], targetLength, radix)
    tmp = AddExp({1}, 0, tmp[1], tmp[2], targetLength, radix)
    return tmp
end function

global function EunExpFast(Eun numerator, Eun denominator)
-- e^(x/y) = 1 + 2x/(2y-x+x^2/(6y+x^2/(10y+x^2/(14y+x^2/(18y+x^2/(22y+...
    sequence s
    object lookat, ret
    integer targetLength
    atom radix = numerator[4]
    -- expFastHowComplete = {1, 0}
    if radix != denominator[4] then
        printf(1, "Error %d\n", 5)
        abort(1/0)
    end if
    if numerator[3] > denominator[3] then
        targetLength = numerator[3]
    else
        targetLength = denominator[3]
    end if
--    if denominator[2] = 0 and equal(denominator[1], {1}) then
--        return EunExp(numerator)
--    end if
    calculating = ID_ExpFast -- begin calculating
    while calculating with entry do
        --lookat = ret
        --if expFastIter > 2 then
        --    expFastHalf = 1 --  -- power(2, 0)
        --    expFastIter -= expFastHalf
        --end if
        lookat = ExpFast(numerator[1], numerator[2], denominator[1], denominator[2], targetLength + 1, radix, expFastIter - 1)
        -- if useExtraAdjustRound then
        --     tmp1 = AdjustRound(tmp1[1], tmp1[2], targetLength + adjustRound, tmp1[4], NO_SUBTRACT_ADJUST)
        -- end if
        -- if tmp1[2] = tmp0[2] then
        --     expFastHowComplete = Equaln(tmp1[1], tmp0[1], expFastHowComplete[1])
        --     if expFastHowComplete[1] > targetLength + 1 or expFastHowComplete[1] = expFastHowComplete[2] then
        --         exit
        --     end if
        -- end if
        s = ReturnToUserCallBack(ID_ExpFast, expFastHowComplete, targetLength, ret, lookat, radix)
        ret = s[2]
        expFastHowComplete = s[3]
        ExpFindIter(s[1]) -- once in loop, once out.
        if s[1] then
            exit
        end if
    entry
        ifdef DEBUG_TASK then
            printf(1, "expFastIter in EunExpFast() = %d\n", expFastIter)
        end ifdef
        ret = ExpFast(numerator[1], numerator[2], denominator[1], denominator[2], targetLength + 1, radix, expFastIter)

ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end while
    ifdef DEBUG_TASK then
        printf(1, "expFastIter after EunExpFast() = %d\n", expFastIter)
    end ifdef
    ret = AdjustRound(ret[1], ret[2], targetLength, radix, NO_SUBTRACT_ADJUST)
    return ret
end function


-- NOTE: These functions are not good at big exponents.
-- EunExpFast, not good at e^(100)


global function EunExpFast1(Eun num)
    return EunExpFast(num, NewEun({1}, 0, num[3], num[4]))
end function

global constant eunExpFast1RID = routine_id("EunExpFast1")


include ../../myeunumber/myeun/ExpCommon.e


global function EunExpFastA(Eun x)
    return EunExpId(eunExpFast1RID, x)
end function

