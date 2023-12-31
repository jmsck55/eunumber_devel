
--with define WITHOUT_TRACE

ifdef WITHOUT_TRACE then
with trace
end ifdef

include get.e

include eunumber/eun/EunCombinatoricsInt.e
include eunumber/eun/EunRound.e
include eunumber/eun/Remainder.e

include eunumber/eun/EunAdjustRound.e
include eunumber/eun/EunAdd.e
include eunumber/eun/EunMultiplicativeInverse.e
include eunumber/eun/EunMultiply.e
include eunumber/minieun/Eun.e
-- include eunumber/my.e

--defaultMultMoreAccuracy = 1 -- zero (0) to disable, else one (1) or more (for smaller radixes.)

constant err = 0 --here

constant len = 70

-- constant s = {1,2,3,4,5,6,7,8,9}
constant s = rand(repeat(9, 50))
constant t = NewEun(s, 4, len, 10)

sequence a, b, c, d, config
sequence ta,tb,tc,td
integer fn

--here, testing functions with new getAllLevel (-2,-1,0, or more)
a = t
--/* -- comment out
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
getAllLevel = NORMAL -- TO_EXP
--getAllLevel = len + 2

? a
b = EunCombinatoricsInt(a, 0, 0, getAllLevel)
puts(1, "EunCombinatoricsInt(): ")
? b

c = EunRound(a, {}, getAllLevel)
printf(1, "EunRound(): %f\n", Round(ToAtom(a)))
? c

c = EunCeil(a, getAllLevel)
printf(1, "EunCeil(): %f\n", Ceil(ToAtom(a)))
? c


if CompareExp(b[1], b[2], c[1], c[2]) then
    puts(1, "Not equal!\n")
else
    puts(1, "Equal!\n")
end if


abort(0)

ROUND_TO_NEAREST_OPTION = TRUE
--integerModeFloat = precision
config = NewConfiguration()
a = assign(a, 6, config)
trace(1)
c = EunAdjustRound(a, err, NO_SUBTRACT_ADJUST)
puts(1, "AdjustRound(): ")
? c


abort(0)

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


