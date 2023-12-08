-- Copyright James Cook
-- ExpCommon.e file of EuNumber.

-- -- Exponentiation, e^n1
-- 
-- "ln" is log[e](), "log" is log[10]()
-- 
-- e^n1 = 10^n, solve for n1
-- 10 = radix
-- 
-- e^(n * ln(10)) = 10^n
-- 10^(n1 * log(e)) = e^n1
-- 
-- n * ln(10) = n1
-- 
-- (e^a) * (e^b) = e^(a + b)
-- 
-- e^(m + n * ln(10)) = (e^m) * (e^(n * ln(10))) = (e^m) * (10^n)
-- 
-- n1 - m = n * ln(10)
-- 
-- n1 - n * ln(10) = m, floor(n1 / ln(10)) = n
-- 
-- n = (n1 - m) / (ln(10))
-- 
-- ----
-- 
-- n1 = 55, n = floor(n1 / ln(10)) = floor(55 / ln(10)) = 23
-- 
-- m = n1 - n * ln(10) = 55 - 23 * ln(10) = 2.040542861
-- 
-- e^n1 = (e^m) * (10^n) = 7.694785265 * 10^23 = e^55
-- 
-- 10 can be any radix.
-- n becomes the exponent.
-- 
-- ----
-- 
-- 1. Precalculate:
-- c = ln(radix)
-- 
-- 2. In exp(n1), Eun's:
-- n = floor( n1 / c )
-- 
-- 3. Do the exponentiation:
-- numArray = e^( n1 - (n * c) )
-- 
-- 4. Return the Eun:
-- {numArray, exponent, targetLength = 70, radix = 10}


include ../../eunumber/minieun/Common.e
include ../../eunumber/minieun/Defaults.e
include ../../eunumber/minieun/AdjustRound.e
include EunLog.e


global sequence lnRadix = {}

global function SwapLnRadix(sequence s = lnRadix)
    object oldvalue = lnRadix
    lnRadix = s
    return oldvalue
end function

--NOTE: still working on this file.

global function GetLnRadix(integer targetLength = defaultTargetLength, atom radix = defaultRadix,
        sequence config = {}, integer getAllLevel = NORMAL)
    if (not length(lnRadix)) or (not length(lnRadix[1])) or (lnRadix[3] <= targetLength) or (lnRadix[4] != radix) then
        lnRadix = EunLog({{1}, 1, targetLength + 1, radix}, NORMAL) --here, work on "EunLog()"
    end if
    return AdjustRound(lnRadix[1], lnRadix[2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
end function


include ../../eunumber/eun/Remainder.e
include ../../eunumber/eun/EunAdd.e
include ../../eunumber/eun/EunDivide.e
include ../../eunumber/eun/EunMultiply.e
include ../../eunumber/eun/EunRoundToInt.e

global PositiveInteger expPowerOfTwo = 3 -- 0 to turn off feature, 1 or above to use feature.

global procedure SetExpPowerOfTwo(integer i)
    expPowerOfTwo = i
end procedure

global function GetExpPowerOfTwo()
    return expPowerOfTwo
end function

global function EunExpId(integer eunExpId, sequence n1, integer getAllLevel = NORMAL)
    Eun test = n1
    sequence c, tmp, config
    integer targetLength --, isNeg = IsNegative(n1[1])
    config = GetConfiguration1(n1)
    targetLength = GetActualTargetLength(n1)
    -- 1. Precalculate:
    -- c = ln(radix)
    c = GetLnRadix(targetLength, n1[4], config, TO_EXP)
    -- 2. In exp(n1), Eun's:
    -- n = floor( n1 / c )
    tmp = EunRoundToInteger(EunDivide(n1, c, TO_EXP), TO_EXP)
    -- 3. Do the exponentiation:
    -- numArray = e^( n1 - (n * c) )
    -- e^(y) = e^(y/(2^m))^(2^m)
    -- numArray = e^( (n1-(n*c))/(2^n) )^(2^n)
    -- 3.1. Subtract
    -- n1 - (n * c)
    c = EunSubtract(n1, EunMultiply(tmp, c, TO_EXP), TO_EXP)
    -- 3.2. Divide by a power of two:
    -- e^(n1/(2^n))^(2^n)
    -- tmp = n1/(2^n)
    c = EunDivide(n1, AdjustRound({power(2, expPowerOfTwo)}, 0, targetLength, n1[4], CARRY_ADJUST, config, TO_EUN), TO_EXP)
    -- 3.3. Call Exp function:
    -- tmp = e^(tmp)
    c = call_func(eunExpId, {c})
    -- 3.3. Square the result, n times:
    -- tmp = tmp^(2^n)
    for i = 1 to expPowerOfTwo do
        c = EunSquared(c, TO_EXP)
    end for
    -- 4. Return the Eun:
    c = AdjustRound(c[1], c[2], targetLength, c[4], NO_SUBTRACT_ADJUST, GetConfiguration1(c), getAllLevel)
    return c
end function

