-- Copyright James Cook


include ../../eunumber/minieun/Common.e


global integer adjustPrecision = 4 -- should be a positive integer, or could be a negative integer for inaccurate results.

global function GetAdjustPrecision()
    return adjustPrecision
end function

global procedure SetAdjustPrecision(integer i)
    adjustPrecision = i
end procedure
