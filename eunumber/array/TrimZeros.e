-- Copyright James Cook
-- trim zeros functions of EuNumber.

namespace trimzeros

ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../minieun/NanoSleep.e

-- Function definitions:

global function TrimLeadingZeros1(sequence numArray)
    for i = 1 to length(numArray) do
        if numArray[i] != 0 then
            if i = 1 then
                return numArray
            else
                return numArray[i..$]
            end if
        end if
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return {}
end function

global function TrimLeadingZeros2(sequence numArray)
    while length(numArray) and numArray[1] = 0 do
        numArray = numArray[2..$]
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end while
    return numArray
end function

global function TrimLeadingZeros(sequence a)
    return TrimLeadingZeros1(a)
end function

global function TrimTrailingZeros1(sequence numArray)
    for i = length(numArray) to 1 by -1 do
        if numArray[i] != 0 then
            if i = length(numArray) then
                return numArray
            else
                return numArray[1..i]
            end if
        end if
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return {}
end function

global function TrimTrailingZeros2(sequence numArray)
    while length(numArray) and numArray[$] = 0 do
        numArray = numArray[1..$-1]
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end while
    return numArray
end function

global function TrimTrailingZeros(sequence a)
    return TrimTrailingZeros1(a)
end function
