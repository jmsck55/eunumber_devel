-- Copyright James Cook

include ../minieun/Divide.e
include ../minieun/Common.e
include ../minieun/UserMisc.e
include ../minieun/Eun.e
include ../minieun/GetAll.e

-- EunDivide
global function EunDivide(sequence n1, sequence n2, integer getAllLevel = NORMAL)
    integer targetLength
    sequence s, config
    s = EunCheckAll({n1, n2})
    config = s[3]
    targetLength = s[2]
    return DivideExp(n1[1], n1[2], n2[1], n2[2], targetLength, n1[4], config, getAllLevel)
end function
