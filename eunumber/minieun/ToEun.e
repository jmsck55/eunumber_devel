-- Copyright James Cook
-- ToEun() function of EuNumber.


namespace toeun

ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../array/Negate.e
include ../array/ArrayFuncs.e
include NanoSleep.e
include Common.e
include Defaults.e
include Eun.e
include ConvertExp.e
include ToString.e

ifdef SMALL_CODE then
-- Use old value() function to avoid Intel bug:
    include get.e
elsedef
    include std/get.e
end ifdef

global function StringToNumberExp(sequence st)
    integer isSigned, exp, f
    sequence ob
    if length(st) = 0 then
        return 0 -- undefined
    end if
    isSigned = ('-' = st[1])
    if isSigned or '+' = st[1] then
        st = st[2..length(st)]
    end if
    if equal(st, "inf") then
        -- returns values for +inf (1) and -inf (-1)
        if isSigned then
            return {-1, 0} -- represents negative infinity
        else
            return {1, 0} -- represents positive infinity
        end if
    end if
    f = find('e', st)
    if f = 0 then
        f = find('E', st)
    end if
    if f then
        ob = st[f + 1..length(st)]
        ob = value( ob )
        if ob[1] != GET_SUCCESS then
            return 2 -- error in value() function
        end if
        exp = ob[2]
        st = st[1..f - 1]
    else
        exp = 0
    end if
    while length(st) and st[1] = '0' do
        st = st[2..length(st)]
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end while
    f = find('.', st)
    if f then
        st = st[1..f - 1] & st[f + 1..length(st)]
        exp += (f - 2) -- 2 because f starts at 1. (1 if f starts at 0)
    else
        exp += (length(st) - 1)
    end if
    while length(st) and st[1] = '0' do
        exp -= 1
        st = st[2..length(st)]
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end while
    if length(st) = 0 then
        exp = 0
    end if
    -- st -= '0'
    -- st = AddByDigit(st, -'0')
    for i = 1 to length(st) do
        st[i] -= '0'
        if st[i] > 9 or st[i] < 0 then
            return 1 -- error in input
        end if
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    if isSigned then
        st = Negate(st)
    end if
    return {st, exp}
end function

global sequence toEunFormat = "%e"

global procedure SetToEunFormat(sequence s)
    toEunFormat = s
end procedure

global function GetToEunFormat()
    return toEunFormat
end function

global function ToEun(object s, atom radix = defaultRadix, integer targetLength = defaultTargetLength,
     sequence config = {}, integer getAllLevel = NORMAL)
    -- done.
    atom fromRadix
    if Eun(s) then
        fromRadix = s[4]
        if not length(config) then
            config = GetConfiguration1(s)
        end if
    else
        if atom(s) then
            s = sprintf(toEunFormat, s)
        end if
        s = StringToNumberExp(s) -- same as "ToEun10(s)"
        if atom(s) then
            return s
        end if
        fromRadix = 10
    end if
    s = ConvertExp(s[1], s[2], targetLength, fromRadix, radix, config, getAllLevel)
    return s
end function

-- Routine id for "ToEun()":

global constant ToEun_id = routine_id("ToEun")

