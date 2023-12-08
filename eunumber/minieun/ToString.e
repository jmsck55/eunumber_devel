-- Copyright James Cook
-- ToString() function of EuNumber.


namespace tostring

ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../array/Negate.e
include ../array/ArrayFuncs.e
include Eun.e
include Common.e
include MathConst.e
include UserMisc.e
include ToEun.e

global sequence toStringFormat = "%+d" -- "%+d" -- "%+05d" -- 9 is the limit in 32-bit code.

global procedure SetToStringFormat(sequence s)
    toStringFormat = s
end procedure

global function GetToStringFormat()
    return toStringFormat
end function

-- padWithZeros can be either 0, 1, 2, or 3

global function ToString(object s, FourOptions padWithZeros = 0, integer getAllLevel = NORMAL, sequence extra_arguments = {})
-- converts an Eun, or an atom, to a string.
-- done.
    Eun test
    sequence ret
    integer f, len, exp
    if not Eun(s) then
        s = call_func(ToEun_id, {s} & extra_arguments) -- pass extra_arguments to "ToEun()", "s" is the first argument.
    end if
    if atom(s[1]) then
        if s[1] = 1 then -- (+infinity)
            return "inf"
        elsif s[1] = -1 then -- (-infinity)
            return "-inf"
        end if
        return -1 -- error
    end if
    test = s
    if length(s) >= 5 then -- this truncates it.
        s[3] += s[5] -- gets actual targetLength.
    end if
    if s[4] != 10 then
        abort(1/0)
        -- s = EunConvert(s, 10, Ceil((log(s[4]) / logTen) * s[3]), getAllLevel)
    else
        s = AdjustRound(s[1], s[2], s[3], s[4], NO_SUBTRACT_ADJUST, GetConfiguration1(s), getAllLevel)
    end if
    exp = s[2]
    s = s[1]
    len = length(s)
    if len = 0 then
        s = "0"
        if and_bits(padWithZeros, 1) then
            s = "+" & s
        end if
        if and_bits(padWithZeros, 2) then
            if s[3] then
                s = s & "." & repeat('0', s[3] - 1)
            end if
        end if
        return s & "e" & sprintf(toStringFormat, {0})
    end if
    f = (s[1] < 0)
    if f then
        -- s = - (s)
        s = Negate(s)
    end if
    -- s += '0'
    -- s = AddByDigit(s, '0')
    for i = 1 to length(s) do
        if s[i] > 9 or s[i] < 0 then
            return 1 -- error in input
        end if
        s[i] += '0'
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    if and_bits(padWithZeros, 2) then
        if s[3] > len then
            s = s & repeat('0', s[3] - (len))
        end if
    end if
    if f then
        s = "-" & s
    elsif and_bits(padWithZeros, 1) then
        s = "+" & s
        f = 1
    end if
    -- f = (s[1] = '-')
    f += 1 -- f is now 1 or 2
    if length(s) > f then
        s = s[1..f] & "." & s[f + 1..length(s)]
    end if
    s = s & "e" & sprintf(toStringFormat, exp) -- can only do 18 decimal places for 80-bit, or 15 for 64-bit doubles
    return s
end function
