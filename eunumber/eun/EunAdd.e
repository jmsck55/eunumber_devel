-- Copyright James Cook

-- done.

include ../minieun/AddExp.e
include ../minieun/Common.e
include ../minieun/Eun.e
include ../minieun/GetAll.e
include ../minieun/NanoSleep.e

-- EunAdd
global function EunAdd(sequence n1, sequence n2, integer getAllLevel = NORMAL)
    -- done.
    -- NOTE: don't have mixed positive and negative elements in numArray in an "Eun" datatype.  Use AdjustRound() with AUTO_ADJUST or BORROW_ADJUST.
    integer targetLength
    sequence s, config
    s = EunCheckAll({n1, n2})
    config = s[3]
    targetLength = s[2]
    return AddExp(n1[1], n1[2], n2[1], n2[2], targetLength, n1[4], AUTO_ADJUST, config, getAllLevel)
end function

-- EunSubtract
global function EunSubtract(sequence n1, sequence n2, integer getAllLevel = NORMAL)
    -- done.
    -- NOTE: don't have mixed numbers in an "Eun" datatype.  Use AdjustRound() with AUTO_ADJUST or BORROW_ADJUST.
    integer targetLength
    sequence s, config
    s = EunCheckAll({n1, n2})
    config = s[3]
    targetLength = s[2]
    return SubtractExp(n1[1], n1[2], n2[1], n2[2], targetLength, n1[4], AUTO_ADJUST, config, getAllLevel)
end function

-- EunSum
global function EunSum(sequence data)
    sequence sum
    if not length(data) then
        return NewEun()
    end if
    sum = data[1]
    for i = 2 to length(data) do
        sum = EunAdd(sum, data[i]) -- getAllLevel = NORMAL
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return sum
end function
