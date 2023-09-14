-- Copyright James Cook James Cook
-- Integer, with exponent, datatype

namespace intexp

ifdef BITS64 then
    constant intbits = 62
elsedef
    constant intbits = 30
end ifdef

atom logOf2 = 0

function Log2(atom a)
    if logOf2 = 0 then
        logOf2 = log(2)
    end if
    return log(a) / logOf2
end function

public function NewFromDouble(atom a)
    integer i, exp, isNeg, j
    isNeg = a < 0
    if isNeg then
        a = - (a)
    end if
    exp = floor(Log2(a))
    a = a / power(2, exp)

    -- exp = 0
    -- while a < 1 do
    --     a = a * 2
    --     exp -= 1
    -- end while
    -- while a > 1 do
    --     a = a / 2
    --     exp += 1
    -- end while
    i = 0
    j = 1
    while 1 do
    -- for j = 1 to intbits do
        if floor(a) then
            a -= 1
            i += 1
        elsif a = 0 then
            exit
        end if
        if j = intbits then
            exit
        end if
        a *= 2
        i *= 2
        j += 1
    end while
    if isNeg then
        i = - (i)
    end if
    return {i, exp}
end function

public function ToString(sequence s)
    sequence st
    if s[1] = 0 then
        return "0"
    end if
    -- Need to use ConvertExp.e

    return st
end function

