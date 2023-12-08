-- Copyright James Cook
-- ToAtom() function of EuNumber.


namespace toatom

ifdef WITHOUT_TRACE then
without trace
end ifdef

include Eun.e
include ToString.e

ifdef SMALL_CODE then
-- Use old value() function to avoid Intel bug:
    include get.e
elsedef
    include std/get.e
end ifdef

-- converts to a floating point number
-- takes a string or a "Eun"
global function ToAtom(sequence s, integer getAllLevel = NORMAL)
    -- done.
    if Eun(s) then
        s = ToString(s, 0, getAllLevel)
    end if
    -- expecting a string:
    s = value(s)
    if s[1] = GET_SUCCESS and atom(s[2]) then
        return s[2]
    end if
    return {} -- return empty sequence on error.
end function
