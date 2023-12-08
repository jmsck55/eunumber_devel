-- Copyright James Cook


ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../minieun/Common.e
include Borrow.e
include Carry.e


global function Subtract(sequence numArray, atom radix, integer isMixed = TRUE)
    -- if isMixed == 0 then Carry.
    -- if isMixed == 1 then Carry, and then, Borrow, default.
    -- if isMixed == 2 then Borrow.
    if length(numArray) then
        if numArray[1] < 0 then
            if isMixed != 2 then -- use negative one (-1) to bypass "NegativeCarry()"
                numArray = NegativeCarry(numArray, radix)
            end if
            if isMixed then
                numArray = NegativeBorrow(numArray, radix)
            end if
        else
            if isMixed != 2 then -- use negative one (-1) to bypass "Carry()"
                numArray = Carry(numArray, radix)
            end if
            if isMixed then
                numArray = Borrow(numArray, radix)
            end if
        end if
    end if
    return numArray
end function
