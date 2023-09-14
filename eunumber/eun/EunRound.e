-- Copyright James Cook
-- EunRound() moduled after Euphoria's "round()" function.
-- It should work the same as round(), except for only one number at a time.

include ../minieun/Eun.e
include ../minieun/MultiplicativeInverse.e

include EunAdd.e
include EunMultiply.e
include EunDivide.e
include Remainder.e

sequence myhalf = {0, 0, 0, 0} -- initialized by function EuRound()

global function EunRound(Eun a, Eun precision = NewEun({1}))
    if a[3] != myhalf[3] or a[4] != myhalf[4] then
        myhalf = MultiplicativeInverseExp({2}, 0, a[3], a[4])
    end if
    --here, make like others in "eunumber/eun" folder.
    
    return EunDivide(EunFloor(EunAdd(EunMultiply(a, precision), myhalf)), precision)
end function
