-- Copyright James Cook

--
-- Better idea:
--
-- An integer, and an exponent (radix of 10, or 2). There is 9 decimal places of accuracy on 32-bit.
-- {{i_digits}, i_exponent, i_prec}
--


namespace eud

include get.e -- std/get.e

---- For System Internals:
ifdef BITS64 then
    constant INT_TEN_DIGITS = 18
elsedef
    constant INT_TEN_DIGITS = 9
end ifdef

type Int(atom i)
    return integer(i)
end type
---- End For System Internals.

integer USE_TEN_DIGITS = INT_TEN_DIGITS

public function GetTenDigits()
    return USE_TEN_DIGITS
end function

public procedure SetTenDigits(integer i)
    if i <= INT_TEN_DIGITS then
        USE_TEN_DIGITS = i
    end if
end procedure


function min(atom a, atom b)
    if a <= b then
        return a
    else
        return b
    end if
end function

constant FALSE = 0, TRUE = 1


public type eud(sequence s)
    if length(s) = 2 then
        if sequence(s[1]) then
            if integer(s[2]) then
                if integer(s[3]) then
                    return 1
                end if
            end if
        end if
    end if
    return 0
end type

public function NewEuDouble(sequence s = {0}, integer exp = 0, integer prec = INT_TEN_DIGITS)
    eud d = {s, exp, prec}
    return d
end function


public function FromDecimal(sequence st)
    Int a
    sequence s
    integer ch, sign, exp, count
    if length(st) = 0 then
        return {}
    end if
    sign = FALSE
    if st[1] = '-' then
        sign = TRUE
        st = st[2..$]
    elsif st[1] = '+' then
        st = st[2..$]
    end if
    while length(st) and st[1] = '0' do -- trim leading zeros.
        st = st[2..$]
    end while
    while length(st) and st[$] = '0' do -- trim trailing zeros.
        st = st[1..$ - 1]
    end while
    exp = find('.', st)
    if exp then
        st = st[1..exp - 1] & st[exp + 1..$]
        exp = exp - 2
    end if
    while length(st) and st[1] = '0' do -- trim leading zeros, and decrement exp.
        st = st[2..$]
        exp -= 1
    end while
    -- Padding:
    st = st & repeat('0', USE_TEN_DIGITS - remainder(length(st), USE_TEN_DIGITS))
    s = repeat(0, floor(length(st) / USE_TEN_DIGITS))
    count = 0
    for i = 1 to length(st) by USE_TEN_DIGITS do -- limit to double, radix 10, digits.
        a = 0
        for j = i to i + USE_TEN_DIGITS - 1 do
            ch = st[j] - '0'
            a *= 10 -- might reach infinity, make sure it doesn't.
            a += ch
        end for
        count += 1
        s[count] = a
    end for
    if sign then
        s *= -1
    end if
    return {s, exp}
end function


public function FromExp(sequence st)
    atom a
    sequence s
    integer exp, f
    f = find(st, 'e')
    if not f then
        f = find(st, 'E')
    end if
    exp = 0
    if f then
        s = value(st[f + 1..$])
        if s[1] != GET_SUCCESS or not integer(s[2]) then
            return -1
        end if
        exp = s[2]
        st = st[1..f - 1]
    end if
    s = FromDecimal(st)
    s[2] += exp
    return {s, exp}
end function


public function ToString(eud d)
    sequence s
    
    

    return {}
end function
