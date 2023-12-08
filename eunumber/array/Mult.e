-- Copyright James Cook


ifdef WITHOUT_TRACE then
without trace
end ifdef


include ../minieun/NanoSleep.e


global integer tinyFastMult1 = 3

global procedure SetTinyFastMult1(integer a)
    tinyFastMult1 = a
end procedure

global function GetTinyFastMult1()
    return tinyFastMult1
end function

global function Mult1(sequence n1, sequence n2)
    integer c
    sequence numArray
-- This method may be faster:
    numArray = repeat(0, length(n1) + length(n2) - 1)
    for a = 1 to length(n1) do
        c = a
        for b = 1 to length(n2) do
            numArray[c] += n1[a] * n2[b]
            c += 1
ifdef not NO_SLEEP_OPTION then
            sleep(nanoSleep)
end ifdef
        end for
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return numArray
end function


include ../minieun/UserMisc.e


global function Mult2(sequence n1, sequence n2, integer minLen = length(n1) + length(n2) - 1)
    integer b, f
    sequence numArray
-- This method may be faster:
    numArray = repeat(0, minLen)
    f = length(n2)
    for a = 1 to length(n1) do
        if n1[a] then
            b = 1
            for c = a to min(minLen, f) do
                if n2[b] then
                    numArray[c] += n1[a] * n2[b]
                end if
                b += 1
                ifdef not NO_SLEEP_OPTION then
                    sleep(nanoSleep)
                end ifdef
            end for
        end if
        f += 1
        ifdef not NO_SLEEP_OPTION then
            sleep(nanoSleep)
        end ifdef
    end for
    return numArray
end function


include ../minieun/Defaults.e


integer lastAdjust, lastLen = 0
atom lastRadix = 0

global function Multiply(sequence n1, sequence n2, sequence len_radix = {}, integer multMoreAccuracy = defaultMultMoreAccuracy)
    integer len, len2
    sequence numArray
    if length(n1) = 0 or length(n2) = 0 then
        return {}
    end if
    len = length(n1) + length(n2) - 1
    if len <= tinyFastMult1 then
        return Mult1(n1, n2)
    end if
    if length(len_radix) then
        if len_radix[1] != lastLen or len_radix[2] != lastRadix then
            lastAdjust = Ceil(log(len_radix[1]) / log(len_radix[2]))
            lastLen = len_radix[1]
            lastRadix = len_radix[2]
        end if
        len2 = len_radix[1] + lastAdjust + multMoreAccuracy
        if len2 < len then
            len = len2
        end if
    end if
    return Mult2(n1, n2, len)
end function

global function Squared(sequence n1, sequence len_radix = {}, integer multMoreAccuracy = defaultMultMoreAccuracy)
    return Multiply(n1, n1, len_radix, multMoreAccuracy) -- multiply it by its self, once
end function
