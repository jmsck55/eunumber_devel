-- Copyright James Cook


ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../minieun/NanoSleep.e

global function MultiplyByDigit(sequence n1, object digit)
-- <script>
-- function MultiplyByDigit(n1, digit)
-- {
--     return n1.map((x) => x * digit);
-- }
-- </script>    
ifdef OLD_PROCESSOR_MODE then
    return n1 * digit
elsedef
    for j = 1 to length(n1) do
        n1[j] *= digit
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return n1
end ifdef
end function

global function AddByDigit(sequence n1, object digit)
ifdef OLD_PROCESSOR_MODE then
    return n1 + digit
elsedef
    for j = 1 to length(n1) do
        n1[j] += digit
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return n1
end ifdef
end function

