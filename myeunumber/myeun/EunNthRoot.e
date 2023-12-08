-- Copyright James Cook

include ../../eunumber/minieun/NanoSleep.e
include ../../eunumber/minieun/Common.e
include ../../eunumber/minieun/Multiply.e
include ../../eunumber/minieun/Divide.e
include ../../eunumber/minieun/AddExp.e
include ../../eunumber/minieun/Defaults.e
include ../../eunumber/minieun/UserMisc.e
include ../../eunumber/minieun/AdjustRound.e
include ../../eunumber/minieun/ReturnToUser.e
include ../../eunumber/minieun/Eun.e
include ../../eunumber/minieun/ToAtom.e
include ../../eunumber/minieun/ToEun.e
include ../../eunumber/minieun/ConvertExp.e
include ../../eunumber/array/Negate.e

include RealMode.e

--nthroot.e

-- NthRoot algorithm

-- Find the nth root of any number

global function IntPowerExp(PositiveInteger toPower, sequence n1, integer exp1,
     integer targetLength, atom radix, sequence config, integer getAllLevel = NORMAL)
-- b^x = e^(x * ln(b))
    sequence p
    if toPower = 0 then
        return {{1}, 0, targetLength, radix}
    end if
    p = {n1, exp1}
    for i = 2 to toPower do
        p = MultiplyExp(p[1], p[2], n1, exp1, targetLength, radix, CARRY_ADJUST, config, TO_EXP)
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    p = AdjustRound(p[1], p[2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
    return p
end function

-- function NthRoot(object x, object guess, object n)
--      object quotient, average
--      quotient = x / power(guess, n-1)
--      average = (quotient + ((n-1) * guess)) / n
--      return average
-- end function

global function NthRootProtoExp(PositiveScalar n, sequence x1, integer x1Exp,
     sequence guess, integer guessExp, integer targetLength, atom radix,
     sequence config, integer getAllLevel = NORMAL)
    sequence p, quot, average
    p = IntPowerExp(n - 1, guess, guessExp, targetLength, radix, config, TO_EXP)
    quot = DivideExp(x1, x1Exp, p[1], p[2], targetLength, radix, config, TO_EXP)
    p = MultiplyExp({n - 1}, 0, guess, guessExp, targetLength, radix, CARRY_ADJUST, config, TO_EXP)
    p = AddExp(p[1], p[2], quot[1], quot[2], targetLength, radix, AUTO_ADJUST, config, TO_EXP)
    average = DivideExp(p[1], p[2], {n}, 0, targetLength, radix, config, getAllLevel)
    return average
end function

global PositiveOption nthRootMoreAccuracy = -1 -- if -1, then use calculationSpeed

global procedure SetNthRootMoreAccuracy(PositiveOption i)
    nthRootMoreAccuracy = i
end procedure
global function GetNthRootMoreAccuracy()
    return nthRootMoreAccuracy
end function

global integer nthRootIter = 1000000000

global sequence nthRootHowComplete = {1, 0}

global function GetNthRootHowCompleteMin()
    return nthRootHowComplete[1]
end function

global function GetNthRootHowCompleteMax()
    return nthRootHowComplete[2]
end function

global constant ID_NthRoot = 3

global function NthRootExp(PositiveScalar n, sequence x1, integer x1Exp, sequence guess, integer guessExp,
     integer targetLength, atom radix, sequence config = {}, integer getAllLevel = NORMAL)
    sequence lookat, ret, s
    integer protoTargetLength, moreAccuracy, lastNthRootIter
    nthRootHowComplete = {1, 0}
    if length(x1) = 0 then
        nthRootHowComplete = {0, 0}
        lastNthRootIter = 1
        return {x1, x1Exp, targetLength, radix}
    end if
    if length(x1) = 1 then
        if x1[1] = 1 or x1[1] = -1 then
            nthRootHowComplete = {1, 1}
            lastNthRootIter = 1
            return {x1, x1Exp, targetLength, radix}
        end if
    end if
    if nthRootMoreAccuracy >= 0 then
        moreAccuracy = nthRootMoreAccuracy
    elsif calculationSpeed then
        moreAccuracy = Ceil(targetLength / calculationSpeed)
    else
        moreAccuracy = 0 -- changed to 0
    end if
    -- Use adjustPrecision for higher order functions, such as Trig functions.
    -- targetLength += adjustPrecision
    protoTargetLength = targetLength + moreAccuracy + 1
    ret = AdjustRound(guess, guessExp, protoTargetLength, radix, CARRY_ADJUST, config, NORMAL) -- TO_EXP)
    lookat = {}
    calculating = ID_NthRoot -- begin calculating
    lastNthRootIter = 1
    while calculating and lastNthRootIter <= nthRootIter do
    -- for i = 1 to nthRootIter do
        --lookat = ret
        ret = NthRootProtoExp(n, x1, x1Exp, ret[1], ret[2], protoTargetLength, radix,
         config, TO_EXP)
        --guess = ret[1]
        --guessExp = ret[2]
        --if useExtraAdjustRound then
        --    ret = AdjustRound(guess, guessExp, targetLength + adjustRound, radix, NO_SUBTRACT_ADJUST)
        --end if
        --if ret[2] = lookat[2] then
        --    nthRootHowComplete = Equaln(ret[1], lookat[1], nthRootHowComplete[1]) -- , targetLength - adjustRound)
        --    if nthRootHowComplete[1] > targetLength + 1 or nthRootHowComplete[1] = nthRootHowComplete[2] then
        --    -- if equal(ret[1], lookat[1]) then
        --        exit
        --    end if
        --end if
        s = ReturnToUserCallBack(ID_NthRoot, nthRootHowComplete, targetLength, ret, lookat, radix, config)
        lookat = s[2]
        nthRootHowComplete = s[3]
        if s[1] then
            exit
        end if
        lastNthRootIter += 1
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end while
    -- end for
    if lastNthRootIter = nthRootIter then
        printf(1, "Error %d\n", 3)
        abort(1/0)
    end if
    ret = AdjustRound(ret[1], ret[2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
    return ret
end function

global function EunNthRoot(PositiveScalar n, sequence n1, object guess = 0, integer getAllLevel = NORMAL)
    Eun test = n1
    integer isImag, exp1, f
    sequence ret, config
    atom a
    config = GetConfiguration1(n1)
    integer firstFlag = and_bits(getAllLevel, GET_ALL)
    integer lastFlag = and_bits(getAllLevel, TO_EXP)
    if atom(guess) then
        -- Latest code:
        exp1 = n1[2]
        f = remainder(exp1, n)
        if f then
            exp1 -= f
            if exp1 <= 0 then
                exp1 += n
            end if
        end if
        n1[2] -= exp1
        guess = ToAtom(n1)
        a = guess
        if a < 0 then
            -- factor out sqrt(-1), an imaginary number, on even roots
            a = - (a) -- atom
            f = IsIntegerOdd(n)
        else
            f = 0
        end if
        a = power(a, 1 / n)
        if f then
            a = - (a) -- atom
        end if
        guess = ToEun(a, n1[4], n1[3], config, NORMAL, "%e")
        -- guess = ToEun(sprintf("%e", a), n1[4], n1[3])
    else
        exp1 = 0
    end if
    if n1[4] != guess[4] then -- still needed if guess is supplied as an argument of this function.
        guess = EunConvert(guess, n1[4], n1[3], TO_EXP + firstFlag)
    end if
    if IsIntegerEven(n) then
        if length(n1[1]) and n1[1][1] < 0 then
            if realMode then
                printf(1, "Error %d\n", 4)
                abort(1/0)
            end if
            -- factor out sqrt(-1)
            isImag = 1
            n1[1] = Negate(n1[1])
        else
            isImag = 0
        end if
        if IsNegative(guess[1]) then
            guess[1] = Negate(guess[1])
        end if
    end if
    ret = NthRootExp(n, n1[1], n1[2], guess[1], guess[2], n1[3], n1[4], config, lastFlag)
    exp1 = floor(exp1 / n)
    ret[2] += exp1
    if IsIntegerOdd(n) then
        return ret
    else
        n1 = ret
        n1[1] = Negate(n1[1])
        return {isImag, ret, n1} -- n1 = assign(ret, 1, Negate(ret[1])) -- See also, UserMisc.e for "assign()".
    end if
end function
