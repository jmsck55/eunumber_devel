-- Copyright James Cook

--here, use "EunFunc1()" functions, instead of "Func1Exp()" functions.

include ../../eunumber/minieun/NanoSleep.e
include ../../eunumber/minieun/Common.e
include ../../eunumber/minieun/Defaults.e
include ../../eunumber/minieun/UserMisc.e
include ../../eunumber/minieun/ReturnToUser.e
include ../../eunumber/minieun/Multiply.e
include ../../eunumber/minieun/AddExp.e
include ../../eunumber/minieun/Divide.e
include ../../eunumber/minieun/MultiplicativeInverse.e
include ../../eunumber/minieun/AdjustRound.e
include ../../eunumber/minieun/CompareFuncs.e
include ../../eunumber/array/Negate.e
include ../../eunumber/array/WholeFracParts.e


global constant FIND_POWER_LESS_THAN = 0, FIND_POWER_FLOOR = 1, FIND_POWER_CEIL = 2, FIND_POWER_INF = 3

global function FindPowerOfExp(sequence n1, integer exp1, integer targetLength, atom radix,
        sequence n2 = {2}, integer exp2 = 0, integer greaterThan = FIND_POWER_INF, sequence config = {})
    -- Defaults to power of 2.
    -- Find the first power of n2 that is greater than n1
    -- Or the first power of (1 / n2) that is less than n1
    sequence x = {{1}, 0, targetLength, radix}
    integer cmp
    atom n = 0
    if isRoundToZero then --here, what am I doing here?  What about EunGetAllToExp() ??
        exp1 *= 2
        n1 = AdjustRound(n1, exp1, targetLength, radix, NO_SUBTRACT_ADJUST, config, TO_EXP) -- we want to round.
        exp1 = floor(n1[2] / 2)
        n1 = n1[1]
    end if
    if length(n1) then
        cmp = CompareExp({1}, 0, n1, exp1)
        if cmp = 1 then
            x = MultiplicativeInverseExp(n1, exp1, targetLength, radix, {}, config, TO_EXP)
            n1 = x[1]
            exp1 = x[2]
        end if
        x = DivideExp(n1, exp1, n2, exp2, targetLength, radix, config, TO_EXP)
        x = WholeFracParts(x[1], x[2], WF_WHOLE_PART, config, greaterThan)
        x = x[1] & targetLength & radix
        n = ToAtom(x, TO_EXP)
        x = {{1}, 0}
        for i = 1 to n do
            x = MultiplyExp(x[1], x[2], n2, exp2, targetLength, radix, CARRY_ADJUST, config, TO_EXP)
ifdef not NO_SLEEP_OPTION then
            sleep(nanoSleep)
end ifdef
        end for
        if cmp = 1 then
            n = - (n)
        end if
    end if
    return {n, x}
--    if length(n1) then
--        cmp = CompareExp(x[1], x[2], n1, exp1)
--        if cmp = 1 then
--            n1 = MultiplicativeInverseExp(n1, exp1, targetLength, radix)
--            exp1 = n1[2]
--            n1 = n1[1]
--            addOne = -1
--            cmp = -1
--        end if
--        while cmp = -1 do
--            x = MultiplyExp(x[1], x[2], n2, exp2, targetLength, radix)
--            n += addOne
--            cmp = CompareExp(x[1], x[2], n1, exp1)
--ifdef not NO_SLEEP_OPTION then
--        sleep(nanoSleep)
--end ifdef
--        end while
--    end if
end function


global function SquareExpN(integer n, sequence n1, integer exp1, integer targetLength, atom radix,
        sequence config = {})
    -- n >= 0, or MultiplicativeInverse(x) with abs(n) >= 0
    sequence x = {n1, exp1, targetLength, radix}
    n = abs(n)
    for i = 1 to n do
        x = SquaredExp(x[1], x[2], targetLength, radix, CARRY_ADJUST, config, TO_EXP)
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return x
end function


global PositiveOption expMoreAccuracy = -1 -- if -1, then use calculationSpeed

global procedure SetExpMoreAccuracy(PositiveOption i)
    expMoreAccuracy = i
end procedure
global function GetExpMoreAccuracy()
    return expMoreAccuracy
end function

global integer expExpIter = 1000000000
global integer expExpCount = 0

global sequence expHowComplete = {1, 0} -- should these be incapslated in the function?  Yes. --here TODO.

global function GetExpHowCompleteMin()
    return expHowComplete[1]
end function

global function GetExpHowCompleteMax()
    return expHowComplete[2]
end function

global constant ID_Exp = 4

-- Raw function: Natural Exponentiation

global function NaturalExponentiationExp(sequence n1, integer exp1, TargetLength protoTargetLength, atom radix,
    integer targetLength, sequence config = {}, integer getAllLevel = NORMAL)
--
-- using taylor series
-- https://en.wikipedia.org/wiki/TaylorSeries
--
-- -- exp(1) = sum of k=0 to inf (1/k!)
-- -- exp(x) = sum of k=0 to inf ((x^k)/k!)
--
-- atom x
-- x = 1 -- input
--
-- atom sum, num, den
-- num = 1
-- den = 1
-- sum = 1
-- for i = 1 to 100 do
--      num *= x
--      den *= i -- number of iterations
--      sum += ( num / den )
-- end for
--
-- ? sum
    sequence num, den, sum, tmp, count, lookat, s, config2
    expHowComplete = {1, 0, {}}
    if not length(config) then -- new code.
        config = NewConfiguration()
    end if
    config2 = config
    config2[4] = {TRUE, 0} -- IntegerMode for count.
    num = {{1}, 0}
    den = num
    count = num
    sum = {{1}, 0, protoTargetLength, radix}
    lookat = {}
    calculating = ID_Exp -- begin calculating
    expExpCount = 1
    while calculating and expExpCount <= expExpIter do
        num = MultiplyExp(num[1], num[2], n1, exp1, protoTargetLength, radix, CARRY_ADJUST, config, TO_EXP)
        den = MultiplyExp(den[1], den[2], count[1], count[2], protoTargetLength, radix, CARRY_ADJUST, config, TO_EXP)
        tmp = DivideExp(num[1], num[2], den[1], den[2], protoTargetLength, radix, config, TO_EXP)
        --lookat = sum
        sum = AddExp(sum[1], sum[2], tmp[1], tmp[2], protoTargetLength, radix, AUTO_ADJUST, config, TO_EXP)
        --if useExtraAdjustRound then
        --     sum = AdjustRound(sum[1], sum[2], targetLength + adjustRound, radix, NO_SUBTRACT_ADJUST)
        --end if
        --if sum[2] = lookat[2] then
        --    expHowComplete = Equaln(sum[1], lookat[1], expHowComplete[1]) -- , targetLength) -- + adjustRound)
        --    if expHowComplete[1] > targetLength + 1 or expHowComplete[1] = expHowComplete[2] then -- how equal are they? Use tasks to report on how close we are to the answer.
        --    -- if equal(sum[1], lookat[1]) then
        --        exit
        --    end if
        --end if
        s = ReturnToUserCallBack(ID_Exp, expHowComplete, targetLength, sum, lookat, radix, config)
        lookat = s[2]
        expHowComplete = s[3]
        if s[1] then
            exit
        end if
        expExpCount += 1
        count = AddExp(count[1], count[2], {1}, 0, protoTargetLength, radix, CARRY_ADJUST, config2, TO_EXP)
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end while
    if expExpCount = expExpIter then
        printf(1, "Error %d\n", 3)
        abort(1/0)
    end if
    sum = AdjustRound(sum[1], sum[2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
    return sum
end function

--here: Used in GetE(), used by EunLog.e, used by ExpCommon.e, used by EunExp.e

global function ExpExp(sequence n1, integer exp1, integer targetLength, atom radix,
        Bool factor = TRUE, sequence config = {}, integer getAllLevel = NORMAL)
-- it doesn't like large numbers.
-- so, factor.
--
--      e^(a+b) <=> e^(a) * e^(b)
--      e^(whole+frac) <=> EunExpWhole(E,whole) * EunExp(fract)
--
-- e^(a*x/a) <=> (e^(x/a))^a
-- e^(2^n * x / 2^n) <=> e^(x/2^n)^(2^n)
--
-- Example: (Part 1 and Part 2)
--
-- e^230
-- find a power of two greater than 230.
-- {n, p} = FindPowerOfTwoGreaterThan(230) -- Part 1.
-- p = 256
-- ln(256)/ln(2) = 8 = n
-- 230/256 = c
-- c < 1
-- e^(c) = b
-- f(x) = x^2
-- f of fy(x) = g(x, y) = SquareN(y, x)
-- g(b, n) = ans = SquareN(n, b) -- Part 2.

    sequence sum
    integer protoTargetLength, moreAccuracy, n, isNeg
    expHowComplete = {1, 0}
    if expMoreAccuracy >= 0 then
        moreAccuracy = expMoreAccuracy
    elsif calculationSpeed then
        moreAccuracy = Ceil(targetLength / calculationSpeed)
    else
        moreAccuracy = 0 -- changed to 0
    end if
    -- targetLength += adjustPrecision
    protoTargetLength = targetLength + moreAccuracy + 1
    isNeg = IsNegative(n1)
    if isNeg then -- Take the absolute value of the number, while saving isNeg.
        n1 = Negate(n1)
    end if
-- Part 1 of Exp():
    if factor then
        sequence den, tmp, s
        s = FindPowerOfExp(n1, exp1, protoTargetLength, radix, {2}, 0, FIND_POWER_INF, config)
        n = s[1]
        den = s[2]
        tmp = DivideExp(n1, exp1, den[1], den[2], protoTargetLength, radix, config, TO_EXP)
        n1 = tmp[1]
        exp1 = tmp[2]
    end if
-- End Part 1 of Exp().
    sum = NaturalExponentiationExp(n1, exp1, protoTargetLength, radix, targetLength, config, TO_EXP)
-- Part 2 of Exp():
    if factor then
        sum = SquareExpN(n, sum[1], sum[2], protoTargetLength, radix, config) -- What is 'n', should it be "SquareExpN()" or multiplied ?
    end if
-- End Part 2 of Exp().
    if isNeg then
        sum = MultiplicativeInverseExp(sum[1], sum[2], protoTargetLength, radix, {}, config, TO_EXP)
    end if
    sum = AdjustRound(sum[1], sum[2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
    return sum
end function


-- NOTE: These don't work with "0.001" as a parameter:
-- EunExpB() is better at e^(100)
-- EunExpA() is inaccurate at e^(100)

global function EunExpA(Eun num, integer getAllLevel = NORMAL)
    num = ExpExp(num[1], num[2], num[3], num[4], TRUE, GetConfiguration1(num), getAllLevel)
    return num
end function

global constant eunExpARID = routine_id("EunExpA")

--here, looking at ExpCommon.e, then EunLog.e, and back to EunExp() function files.
include ExpCommon.e

global function EunExpB(Eun num, integer getAllLevel = NORMAL)
    return EunExpId(eunExpARID, num, getAllLevel)
end function
