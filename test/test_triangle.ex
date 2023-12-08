-- Copyright James Cook

--TODO:
-- [ ] Test all functions of "EunTriangulation.e"
-- [x] Test "EunGenericTriangulation()"
-- [ ] Work on something else, like EunExp() functions.

with trace

include ../eunumber/my.e

object pi, a, b, c, d

constant DEBUG = 0

trace(DEBUG)

a = ToEun("0.8")
a = EunArcCos(a)

pi = GetPI()

c = EunDivide(pi, NewEun({2}))

b = EunSubtract(c, a)

trace(DEBUG)

? a
? b
? c
? pi

--here:
-- EunGetAngle():
-- global function EunGetAngle(Eun angleB, object distanceBetween = 0, object oppositeB = 0, object oppositeA = 0)

? EunTriangulationASA(a, b, NewEun({5}))

/*
{
  {6,4,3,5,0,1,1,0,8,7,9,3,2,8,4,3,8,6,8,0,2,8,0,9,2,2,8,7,1,7,3,2,2,6,3,8,0,4,1,5,1,0,5,9,1,1,1,5,3,1,2,3,8,2,8,6,5,6,0,6,1,1,8,7,1,3,5,1,2,4},
  -1,
  70,
  10,
  {
    {0,0,2,6,7,5},
    -70
  }
}
{
  {9,2,7,2,9,5,2,1,8,0,0,1,6,1,2,2,3,2,4,2,8,5,1,2,4,6,2,9,2,2,4,2,8,8,0,4,0,5,7,0,7,4,1,0,8,5,7,2,2,4,0,5,2,7,6,2,1,8,6,6,1,7,7,4,4,0,3,9,5,6},
  -1,
  70,
  10,
  {}
}
{
  {1,5,7,0,7,9,6,3,2,6,7,9,4,8,9,6,6,1,9,2,3,1,3,2,1,6,9,1,6,3,9,7,5,1,4,4,2,0,9,8,5,8,4,6,9,9,6,8,7,5,5,2,9,1,0,4,8,7,4,7,2,2,9,6,1,5,3,9,0,8},
  0,
  70,
  10,
  {
    {0,0},
    -69
  }
}
{
  {3,1,4,1,5,9,2,6,5,3,5,8,9,7,9,3,2,3,8,4,6,2,6,4,3,3,8,3,2,7,9,5,0,2,8,8,4,1,9,7,1,6,9,3,9,9,3,7,5,1,0,5,8,2,0,9,7,4,9,4,4,5,9,2,3,0,7,8,1,6},
  0,
  70,
  10,
  {
    {-1,6},
    -69
  }
}
*/

--abort(0)

trace(DEBUG)

sequence angles, sides, tmp
angles = repeat(GT_FIND, 3)
sides = {NewEun({3}), NewEun({4}), NewEun({5})}

? {angles, sides}

for i = 1 to 5 do

    tmp = EunGenericTriangulation(angles, sides)
    ? tmp
    angles = tmp[1][2]
    sides = tmp[2][2]
    if tmp[1][1] = -1 and tmp[2][1] = -1 then
        exit
    end if

end for

for i = 1 to length(angles) do
  printf(1, "%d==%s degrees\n", {i, ToStringDecimal(EunRadiansToDegrees(angles[i]))})
end for
for i = 1 to length(sides) do
  printf(1, "%d==%s units\n", {i, ToString(sides[i])})
end for

--abort(0)
-- Now, work on sides:

sides[1] = GT_FIND
--sides[2] = GT_FIND
--sides[3] = 0 -- GT_FIND

angles[1] = 0 -- GT_FIND
angles[2] = 0 -- GT_FIND
--angles[3] = GT_FIND

for i = 1 to 5 do

    trace(0)
    tmp = EunGenericTriangulation(angles, sides)
    ? tmp
    angles = tmp[1][2]
    sides = tmp[2][2]
    if tmp[1][1] = -1 and tmp[2][1] = -1 then
        trace(0)
        exit
    end if
end for

? sides

for i = 1 to length(angles) do
    if sequence(angles[i]) then
        printf(1, "%d==%s degrees\n", {i, ToStringDecimal(EunRadiansToDegrees(angles[i]))})
    end if
end for
for i = 1 to length(sides) do
    if sequence(sides[i]) then
        printf(1, "%d==%s units\n", {i, ToString(sides[i])})
    end if
end for
