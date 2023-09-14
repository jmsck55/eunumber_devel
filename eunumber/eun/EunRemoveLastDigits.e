-- Copyright James Cook


include ../minieun/Eun.e
include ../minieun/AdjustRound.e


-- NOTE: Most functions are designed to be accurate to the last digit but,
-- sometimes we want something less accurate.
-- To get less accurate results, you can use "RemoveLastDigits()".
global function RemoveLastDigits(sequence num, integer digits = 1, PositiveInteger minlength = 0)
    integer newlen
    newlen = length(num) - digits
    if newlen < minlength then
        newlen = minlength
    end if
    if newlen <= 0 then
        return {}
    end if
    if newlen < length(num) then
        num = num[1..newlen]
    elsif newlen > length(num) then
        num = num & repeat(0, newlen - length(num))
    end if
    return num
end function

global function EunRoundLastDigits(Eun n1, integer digits = 1, PositiveInteger minlength = 0)
    -- digits is an integer.
    integer newlen
    sequence a

    newlen = length(n1[1]) - digits
    if newlen < minlength then
        newlen = minlength
    end if

    a = EunGetAll(n1)
    a = AdjustRound(a[1], a[2], newlen, a[4], NO_SUBTRACT_ADJUST)
    return a
end function
