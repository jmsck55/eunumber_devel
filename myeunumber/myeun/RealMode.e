-- Copyright James Cook


include ../../eunumber/minieun/Common.e


-- Set REAL or COMPLEX mode:

global constant COMPLEX_MODE = 0, REAL_MODE = 1

global Bool realMode = REAL_MODE

global procedure SetRealMode(Bool i)
    realMode = i
end procedure

global function GetRealMode()
    return realMode
end function

