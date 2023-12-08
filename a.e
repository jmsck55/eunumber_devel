
-- NOTES:
-- 1. Multiplication has to use NORMAL rounding.
-- 2. 

--with define WITHOUT_TRACE

ifdef WITHOUT_TRACE then
with trace
end ifdef

include get.e

include eunumber/eun/EunAdjustRound.e
include eunumber/eun/EunMultiplicativeInverse.e
include eunumber/eun/EunMultiply.e
include eunumber/minieun/Eun.e
-- include eunumber/my.e

--defaultMultMoreAccuracy = 1 -- zero (0) to disable, else one (1) or more (for smaller radixes.)

constant err = 0 --here

constant len = 70

-- constant s = {1,2,3,4,5,6,7,8,9}
constant s = rand(repeat(9, 50))
constant t = NewEun(s, 0, len, 10)

sequence a, b, c, d
sequence ta,tb,tc,td
integer fn

--here, testing functions with new getAllLevel (-2,-1,0, or more)
a = t
--/*
fn = open("a.txt", "r")
a = get(fn)
close(fn)
if a[1] != GET_SUCCESS then
    abort(1/0)
end if
a = a[2]
--*/

puts(1, "moreTargetLength=")
? GetMoreTargetLength1(a)

integer getAllLevel
getAllLevel = TO_EXP
--getAllLevel = len + 2

-- a = EunSquared(t, NORMAL)
puts(1, "a=")
? {length(a[1]), a[3]}
b = EunSquared(a, getAllLevel) -- needs the plus two (len + 2)
puts(1, "b=")
? {length(b[1]), b[3]}
c = EunMultiplicativeInverse(a, {}, getAllLevel) -- needs the plus two (len + 2)
? lastIterCount
? c
puts(1, "c=")
? {length(c[1]), c[3]}
d = EunMultiply(b, c, len) -- rounds normally
puts(1, "d=")
? {length(d[1]), d[3]}

ta = EunAdjustRound(a, err, NO_SUBTRACT_ADJUST, len)
? ta
td = EunAdjustRound(d, err, NO_SUBTRACT_ADJUST, len)
? td

if CompareExp(ta[1], ta[2], td[1], td[2]) then
    puts(1, "Not equal!\n")
else
    puts(1, "Equal!\n")
end if

d = EunMultiply(a, d)
-- ? d

tb = EunAdjustRound(b, err, NO_SUBTRACT_ADJUST, len)
? tb
td = EunAdjustRound(d, err, NO_SUBTRACT_ADJUST, len)
? td

if CompareExp(tb[1], tb[2], td[1], td[2]) then
    puts(1, "Not equal!\n")
else
    puts(1, "Equal!\n")
end if

-- ? length(b[1])
-- ? b
-- 
-- d = EunMultiply(b, a)
-- ? length(d[1])
-- ? d
-- 
-- c = EunMultiplicativeInverse(b)
-- 
-- ? CompareExp(a[1], a[2], c[1], c[2])


