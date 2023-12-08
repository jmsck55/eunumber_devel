-- Copyright James Cook
-- EunRound(), similar to Euphoria's "round()" function.
-- It should work the same as round(), except for only one number at a time.

include ../minieun/Eun.e
include ../minieun/Common.e
include ../minieun/MathConst.e
include ../minieun/UserMisc.e
include ../minieun/GetAll.e

include EunMultiplicativeInverse.e
include EunAdd.e
include EunMultiply.e
include EunDivide.e
include Remainder.e

global sequence myhalf = {} -- initialized by function EuRound()

global function EunRound(sequence a, sequence precision = {}, integer getAllLevel = NORMAL)
    -- done.
    -- Steps:
    -- 1a. if getAllLevel is greater than zero (getAllLevel > 0), then set targetLength to getAllLevel (targetLength <=> getAllLevel).
    -- 1b. Set all targetLengths (a[3], b[3], etc.) to getAllLevel (a[3] <=> targetLength).
    -- 2. Use TO_EXP in all functions following it.
    -- 3. At the end, use AdjustRound(), or something similar, with getAllLevel as last parameter.
    integer targetLength
    sequence s, config
    if not length(precision) then
        precision = {oneArray, 0, a[3], a[4]}
    end if
    s = EunCheckAll({a, precision}, TRUE) -- TRUE to set config in Eun arguments.
    config = s[3]
    targetLength = s[2] -- very important
    s = s[1]
    a = s[1]
    precision = s[2]
    if (not length(myhalf)) or (myhalf[3] != targetLength) or (myhalf[4] != a[4]) then
        myhalf = EunMultiplicativeInverse({twoArray, 0, targetLength, a[4]}, {}, TO_EXP) -- get a liitle extra precision
    end if
    a = EunDivide(EunFloor(EunAdd(EunMultiply(a, precision, TO_EXP), myhalf, TO_EXP), TO_EXP), precision, TO_EXP)
    return AdjustRound(a[1], a[2], targetLength, a[4], NO_SUBTRACT_ADJUST, config, getAllLevel)
end function

global function EunRoundRemainder(sequence a, sequence precision = {}, integer getAllLevel = NORMAL)
    -- done.
    sequence rounded, rem
    if getAllLevel = TO_EXP then
        -- returning both "rounded" and "rem"
        -- set this to make sure both have the same targetLength.
        getAllLevel = a[3] + GetMoreTargetLength1(a)
    end if
    rounded = EunRound(a, precision, getAllLevel) -- doesn't return a GET_ALL value.
    rem = EunSubtract(a, rounded, getAllLevel) -- (lastFlag + GET_ALL) -- doesn't need GET_ALL because previous value isn't a GET_ALL value.
    return {rounded, rem} -- returns {rounded, rem}. EunAdd(rounded, rem) == original input.
end function
