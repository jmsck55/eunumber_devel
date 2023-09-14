-- Copyright James Cook
-- Miscellaneous functions of EuNumber.
-- include eunumber/UserMisc.e

namespace usermisc

global function rotate(sequence s, integer rotateby = 1)
    -- shift rotate left is when rotateby is positive.
    -- shift rotate right is when rotateby is negative.
    rotateby = remainder(rotateby, length(s))
    if rotateby > 0 then
        s = s[1 + rotateby..$] & s[1..rotateby]
    elsif rotateby < 0 then
        s = s[$ + rotateby + 1..$] & s[1..$ + rotateby]
    end if
    return s
end function

global function assign(sequence ar, integer index, object val)
    -- assign at
    if length(ar) < index then
        ar = ar & repeat(0, index - length(ar))
    end if
    ar[index] = val
    return ar
end function

global function iff(integer condition, object iftrue, object iffalse)
    if condition then
        return iftrue
    else
        return iffalse
    end if
end function

global function min(atom iftrue, atom iffalse)
    if iftrue < iffalse then
        return iftrue
    else
        return iffalse
    end if
end function

global function max(atom iftrue, atom iffalse)
    if iftrue > iffalse then
        return iftrue
    else
        return iffalse
    end if
end function

global function abs(atom a)
    if a >= 0 then
        return a
    else
        return - (a)
    end if
end function

global function Ceil(atom a)
    return -(floor(-(a)))
end function

global function RoundTowardsZero(atom x)
    if x < 0 then
        return Ceil(x)
    else
        return floor(x)
    end if
end function

global function RoundAwayFromZero(atom x)
    if x > 0 then
        return Ceil(x)
    else
        return floor(x)
    end if
end function

global function Round(object a, object precision = 1)
    return floor(0.5 + (a * precision )) / precision
end function
