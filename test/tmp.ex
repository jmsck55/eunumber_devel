-- Copyright James Cook

ifdef DEBUG then
with trace
end ifdef

include ../eunumber/my.e

-- Finished Testing EunRound().

trace(1)
object a, b, c, d

a = {{2,5,1}, 0, 70, 10}
? a
b = EunRoundRemainder(a)
? b
c = EunGetAllToExp(b)
? c

abort(0)

object x, n1, n2
integer targetLength = 70, radix = 10

integer mode = NORMAL

x = ToEun("2", radix, targetLength, mode)
n2 = ToEun("1020304", radix, targetLength, mode)

trace(1)

x = MultiplyExp(x[1], x[2], n2[1], n2[2], targetLength, radix, mode)
? x
x = MultiplyExp(x[1], x[2], n2[1], n2[2], targetLength, radix, mode)
? x
x = MultiplyExp(x[1], x[2], n2[1], n2[2], targetLength, radix, mode)
? x

--x={{2,1,2,4,3,1,2},18,7,10}
