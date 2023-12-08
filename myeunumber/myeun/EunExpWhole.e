-- Copyright James Cook

--NOTE: Should I use EunGetAllToExp() on this function?

include ../../eunumber/minieun/NanoSleep.e
include ../../eunumber/minieun/Eun.e
include ../../eunumber/minieun/CompareFuncs.e
include ../../eunumber/minieun/AdjustRound.e
include ../../eunumber/minieun/GetAll.e
include ../../eunumber/minieun/AddExp.e
include ../../eunumber/minieun/Multiply.e
include ../../eunumber/minieun/Divide.e


global function Remainder2Exp(sequence n1, integer exp1)
-- returns 1 or 0
    integer n
    n = exp1 + 1 -- reminder.
    if n < 1 then
        return 0
    end if
    if n > length(n1) then
        return 0
    end if
    return remainder(n1[n], 2)
end function

global sequence expWholeHowComplete = {0}

global function GetExpWholeHowCompleteMin()
    return expWholeHowComplete[1]
end function

global function GetExpWholeHowCompleteMax()
    return expWholeHowComplete[2]
end function

global function EunExpWhole(sequence current, sequence q, integer getAllLevel = NORMAL)
-- exp function for whole numbers
    sequence prod, s, config
    integer targetLength, radix, posOrNegOne -- positive or negative one (1 or -1)
    s = EunCheckAll({current, q}) -- TRUE to set config in Eun arguments.
    config = s[3]
    targetLength = s[2]
    expWholeHowComplete = {0} -- used for debugging, see MultiTasking.
    radix = current[4]
    prod = {{1}, 0, targetLength, radix}
    if length(q[1]) = 0 then
        if IsNegative(current[1]) then
            prod[1][1] = -1
        end if
        return prod -- Eun value of one (1).
    end if
    if IsPositive(q[1]) then
        posOrNegOne = 1
    else
        posOrNegOne = -1
    end if
    while 1 do -- ??? what happens if it equals zero (0) ??? [ ] Test it to find out.
        expWholeHowComplete = {q[2]}
        if Remainder2Exp(q[1], q[2]) = posOrNegOne then
            prod = MultiplyExp(prod[1], prod[2], current[1], current[2], targetLength, radix, CARRY_ADJUST, config, TO_EXP)
            q = SubtractExp(q[1], q[2], {posOrNegOne}, 0, targetLength, radix, AUTO_ADJUST, config, TO_EXP) -- subtracts one (1).
        end if
        current = SquaredExp(current[1], current[2], targetLength, radix, CARRY_ADJUST, config, TO_EXP)
        q = DivideExp(q[1], q[2], {2}, 0, targetLength, radix, config, TO_EXP) -- or GET_ALL, or TO_EXP -- divides by two (2).
        if CompareExp(q[1], q[2], {}, 0) != posOrNegOne then
            exit
        end if
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end while
    prod = AdjustRound(prod[1], prod[2], targetLength, prod[4], NO_SUBTRACT_ADJUST, config, getAllLevel)
    return prod
end function

--    isNeg = IsNegative(q[1])
--    if isNeg then -- Take the absolute value of the number, while saving isNeg.
--        q[1] = Negate(q[1])
--    end if
--    while CompareExp(q[1], q[2], {}, 0) = 1 do -- ??? what happens if it equals zero (0) ???
--        expWholeHowComplete = {q[2]}
--        if Remainder2Exp(q[1], q[2]) = 1 then
--            prod = EunMultiply(prod, current)
--            q = EunAdd(q, {{-1}, 0, targetLength, radix}) -- subtracts one (1).
--        end if
--        current = EunSquared(current)
--        q = EunDivide(q, {{2}, 0, targetLength, radix}) -- divides by two (2).
--ifdef not NO_SLEEP_OPTION then
--        sleep(nanoSleep)
--end ifdef
--    end while
----    if CompareExp(q[1], q[2], {}, 0) = 1 then
----        while CompareExp(q[1], q[2], {}, 0) = 1 do
----            expWholeHowComplete = {q[2]}
----            if Remainder2Exp(q[1], q[2]) = 1 then
----                prod = EunMultiply(prod, current)
----                q = EunAdd(q, {{-1}, 0, targetLength, radix}) -- subtracts one (1).
----            end if
----            current = EunSquared(current)
----            q = EunDivide(q, {{2}, 0, targetLength, radix}) -- divides by two (2).
----ifdef not NO_SLEEP_OPTION then
----            sleep(nanoSleep)
----end ifdef
----        end while
----    else
----        while CompareExp(q[1], q[2], {}, 0) = -1 do
----            expWholeHowComplete = {q[2]}
----            if Remainder2Exp(q[1], q[2]) = -1 then
----                prod = EunDivide(prod, current)
----                q = EunAdd(q, {{1}, 0, targetLength, radix}) -- adds one (1).
----            end if
----            current = EunSquared(current)
----            q = EunDivide(q, {{2}, 0, targetLength, radix}) -- divides by two (2).
----ifdef not NO_SLEEP_OPTION then
----            sleep(nanoSleep)
----end ifdef
----        end while
----    end if
--    if isNeg then
--        prod = EunMultiplicativeInverse(prod)
--    end if
