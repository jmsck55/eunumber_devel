-- Copyright James Cook

include ../../eunumber/minieun/Eun.e
include EunNthRoot.e

global function EunFourthRoot(Eun n1, object guess = 0, integer getAllLevel = NORMAL)
    return EunNthRoot(4, n1, guess, getAllLevel)
end function
