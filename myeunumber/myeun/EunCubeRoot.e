-- Copyright James Cook

include ../../eunumber/minieun/Eun.e
include EunNthRoot.e

global function EunCubeRoot(Eun n1, object guess = 0, integer getAllLevel = NORMAL)
    return EunNthRoot(3, n1, guess, getAllLevel)
end function
