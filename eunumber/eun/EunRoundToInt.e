-- Copyright James Cook


--include ../minieun/Eun.e
--include ../minieun/Defaults.e
include ../minieun/Common.e
include EunRoundSignificantDigits.e

-- EunRoundToInt
global function EunRoundToInteger(sequence n1, integer getAllLevel = NORMAL) -- Round to nearest integer
    n1 = EunRoundSignificantDigits(n1, n1[2] + 1, getAllLevel)
    return n1
end function
