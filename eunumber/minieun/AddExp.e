-- Copyright James Cook
-- AddExp and SubtractExp functions of EuNumber.

namespace addexp

ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../array/Add.e
include UserMisc.e
include AdjustRound.e
include Eun.e

global function AddExp(sequence n1, integer exp1, sequence n2, integer exp2, integer targetLength, atom radix,
     integer isMixed = AUTO_ADJUST, sequence config = {}, integer getAllLevel = NORMAL)
    sequence ret, numArray
    integer size, exponent
    if length(n1) then
        if length(n2) then
            if isMixed = AUTO_ADJUST then
                if n1[1] = 0 or n2[1] = 0 then
                    puts(1, "Error: Zero found in first element.\n")
                    abort(1/0)
                end if
                isMixed = (n1[1] > 0) xor (n2[1] > 0)
            end if
            exponent = max(exp1, exp2)
            size = (length(n1) - (exp1)) - (length(n2) - (exp2))
            if size < 0 then
                n1 = n1 & repeat(0, - (size))
            elsif size > 0 then
                n2 = n2 & repeat(0, size)
            end if
            numArray = Add(n1, n2)
        else
            if isMixed = AUTO_ADJUST then
                isMixed = NO_SUBTRACT_ADJUST
            end if
            numArray = n1
            exponent = exp1
        end if
    elsif length(n2) then
        if isMixed = AUTO_ADJUST then
            isMixed = NO_SUBTRACT_ADJUST
        end if
        numArray = n2
        exponent = exp2
    else
        numArray = {}
        exponent = 0
    end if
    ret = AdjustRound(numArray, exponent, targetLength, radix, isMixed, config, getAllLevel)
    return ret
end function

ifdef USE_OLD_SUBTR then

include ../array/Negate.e

global function SubtractExp(sequence n1, integer exp1, sequence n2, integer exp2, integer targetLength, atom radix,
     integer isMixed = AUTO_ADJUST, sequence config = {}, integer getAllLevel = NORMAL)
    return AddExp(n1, exp1, Negate(n2), exp2, targetLength, radix, isMixed, config, getAllLevel)
end function

elsedef

------------------------------
-- New SubtractExp() function:
------------------------------

global function SubtractExp(sequence n1, integer exp1, sequence n2, integer exp2, integer targetLength, atom radix,
     integer isMixed = AUTO_ADJUST, sequence config = {}, integer getAllLevel = NORMAL)
    sequence ret, numArray
    integer size, exponent
    if length(n2) then
        if length(n1) then
            if isMixed = AUTO_ADJUST then
                if n1[1] = 0 or n2[1] = 0 then
                    puts(1, "Error: Zero found in first element.\n")
                    abort(1/0)
                end if
                isMixed = (n1[1] > 0) xor (n2[1] < 0)
            end if
            exponent = max(exp1, exp2)
        else
            if isMixed = AUTO_ADJUST then
                isMixed = NO_SUBTRACT_ADJUST
            end if
            exponent = exp2
        end if
        size = (length(n1) - (exp1)) - (length(n2) - (exp2))
        if size < 0 then
            n1 = n1 & repeat(0, - (size))
        elsif size > 0 then
            n2 = n2 & repeat(0, size)
        end if
        numArray = Subtr(n1, n2)
    else
        if isMixed = AUTO_ADJUST then
            isMixed = NO_SUBTRACT_ADJUST
        end if
        numArray = n1
        exponent = exp1
    end if
    ret = AdjustRound(numArray, exponent, targetLength, radix, isMixed, config, getAllLevel)
    return ret
end function

end ifdef
