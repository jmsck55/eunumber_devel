-- Copyright James Cook
-- Divide function of EuNumber.

namespace divide

ifdef WITHOUT_TRACE then
without trace
end ifdef

include Common.e
include Defaults.e
include MultiplicativeInverse.e
include Multiply.e

-- Divide:

global function DivideExp(sequence num1, integer exp1, sequence den2, integer exp2, integer targetLength, atom radix,
        sequence config = {}, integer getAllLevel = NORMAL)
    sequence ret
    if length(den2) = 0 then -- num/0
        if length(num1) = 0 then -- 0/0
            if zeroDividedByZero then
                return {{1}, 0, targetLength, radix}
            end if
            return 0
        end if
        return (num1[1] > 0) - (num1[1] < 0)
    elsif length(num1) = 0 then -- 0/num
        return {{}, 0, targetLength, radix}
    end if
    ret = MultiplicativeInverseExp(den2, exp2, targetLength, radix, {}, config, TO_EXP)
    if not length(ret) then
        return {}
    end if
    ret = MultiplyExp(num1, exp1, ret[1], ret[2], targetLength, radix, CARRY_ADJUST, config, TO_EXP)
    return AdjustRound(ret[1], ret[2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
    -- the last statement before "return" uses "getAllLevel".
end function

