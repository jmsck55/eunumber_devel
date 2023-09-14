-- Copyright James Cook

include std/console.e

-- with trace

include ../eunumber/my.e

-- trace(1)

--defaultRadix = 10
--defaultTargetLength = 100

--FOR_ACCURACY = FALSE -- TRUE
--multiplicativeInverseMoreAccuracy = 0 -- or it could be -1, to use calculationSpeed

function EunGetAll1(Eun n1)
    -- Get all of the precision, and return as a new "Eun".
    -- Use at the beginning of each "EunFunc1()" function.
    sequence ret
    if length(n1) = 5 and length(n1[5]) then
        ret = AddExp(n1[1], n1[2], n1[5][1], n1[5][2], n1[3] + length(n1[5][1]) - 1, n1[4])
    else
        ret = n1
    end if
    return ret
end function

--here, it works, see below:
-- Work on something else next. See "EunGetAll()" above, and how it's used below:

function TestMultiplicativeInverse(Eun val)
-- This function can be adapted to other functions that use "moreAccuracy" type variables.
    sequence range, n1, n2, n3, n4, a1, a2
    n1 = EunMultiplicativeInverse(val)
    val[3] *= 2
    n2 = EunMultiplicativeInverse(val, a1[1])

    a1 = EunGetAll1(n1)
    a1[3] = n1[3]
    n3 = EunMultiplicativeInverse(a1)
    
    a2 = EunGetAll1(n2)
    a2[3] = val[3]
    n4 = EunMultiplicativeInverse(a2, n3[1])
    -- range = EunTest(n1, n2)
    -- if range[1] < length(n1[1]) then
    --     adjustRound = n1[3] - range[1] -- sets adjustRound
    --     n1 = EunAdjustRound(n1)
    -- end if
    return {n1, n2, n3, n4}
end function


object A, st

while 1 do
    st = prompt_string("Type in a number for MultiplicativeInverse, or press Enter to exit: ")
    
    if length(st) = 0 then
        exit
    end if
    
    A = ToEun(st)

    if sequence(A) then
        ? TestMultiplicativeInverse(A)
    end if
    
end while

puts(1, "Execution completed.\n")

