
--

include eunumber/array/Mult.e
include eunumber/minieun/AdjustRound.e
include eunumber/minieun/Defaults.e
include eunumber/eun/EunAdd.e

with trace

object a, b, c, d
sequence test, lossless

constant radix = 10
constant reps = 70
constant targetLength = reps
defaultTargetLength = targetLength
defaultRadix = radix

--for i = 1 to radix - 1 do
integer i = 7
a = repeat(i, reps)
c = repeat(i, reps)

b = Mult1(a, c)
? Carry(b, radix)

lossless = AdjustRound(b, 0, targetLength, radix)
? lossless

--trace(1)

d = Multiply(a, c, {targetLength, radix})
? Carry(d, radix)
test = AdjustRound(d, 0, targetLength, radix)
? test

if equal(test, lossless) then
    printf(1, "They are equal (%d): ", i)
else
    printf(1, "They are not equal (%d): ", i)
end if

? EunSubtract(lossless, test, TO_EUN)
--end for
