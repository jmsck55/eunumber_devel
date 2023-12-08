-- Copyright James Cook

include ../minieun/Eun.e
include ../minieun/GetAll.e
include ../minieun/Reverse.e

-- EunReverse
global function EunReverse(sequence n1, integer getAllLevel = NORMAL) -- reverse endian
    Eun test = n1
    n1[1] = reverse(n1[1])
    return n1
end function
