-- Copyright James Cook
-- ToStringDecimal() function of EuNumber.


namespace tostringdecimal

ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../array/Negate.e
include ../array/ArrayFuncs.e
include Eun.e
include MathConst.e
include ConvertExp.e
include UserMisc.e
include GetAll.e
include ToEun.e

global function ToStringDecimal(object s, integer getAllLevel = NORMAL, sequence extra_arguments = {})
-- Takes either an Eun(), a character string (returned from ToString()), or an atom.
-- Returns the value in Decimal notation.
-- done.
    Eun test
    sequence ret
    integer exp, pos
    if not Eun(s) then
        s = call_func(ToEun_id, {s} & extra_arguments) -- pass extra_arguments to "ToEun()", "s" is the first argument.
    end if
    if atom(s[1]) then
        if s[1] = 1 then
            return "inf"
        elsif s[1] = -1 then
            return "-inf"
        end if
        return -1 -- error
    end if
    test = s
    if length(s) >= 5 then -- this truncates it.
        s[3] += s[5] -- gets actual targetLength.
    end if
    if s[4] != 10 then
        s = EunConvert(s, 10, Ceil((log(s[4]) / logTen) * s[3]), getAllLevel)
    else
        s = AdjustRound(s[1], s[2], s[3], s[4], NO_SUBTRACT_ADJUST, GetConfiguration1(s), getAllLevel)
    end if
    exp = s[2]
    s = s[1]
    if length(s) = 0 then
        return "0"
    end if
    if s[1] < 0 then
        -- s = - (s)
        s = Negate(s)
        ret = "-"
    else
        ret = ""
        -- st = "+"
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
    if exp < 0 then
        -- 0.01234
        pos = - (exp)
        ret = ret & "0." & repeat('0', pos - 1) & s
    else
        pos = exp + 1
        if pos >= length(s) then -- works.
            -- 123400
            pos -= length(s)
            ret = ret & s & repeat('0', pos)
        else
            -- 12.34
            ret = ret & s[1..pos] & "." & s[pos + 1..$]
        end if
    end if
    return ret
end function
