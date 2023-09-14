-- Copyright James Cook

-- NOTE: Includes files from the "trig" folder.

include ../../eunumber/minieun/Eun.e
include ../../eunumber/minieun/Common.e
include ../../eunumber/minieun/UserMisc.e
include ../../eunumber/eun/EunAdd.e
include ../../eunumber/eun/EunMultiply.e
include ../../eunumber/eun/EunDivide.e
include ../../eunumber/eun/EunMultiplicativeInverse.e

--include ../myeun/EunNthRoot.e
include ../myeun/EunSquareRoot.e

include EunSin.e
include EunCos.e
include EunArcSin.e
include EunArcCos.e
include GetPI.e

--triangulation.e

-- See also, the "EunGenericTriangulation()" function at the end of this file.
-- New Triangulation functions should work.
-- Sometimes, you will have to call "EunGenericTriangulation()" more than once, in a "for loop".

global function EunTriangulationASA(Eun angleA, Eun angleB, Eun sideC)
    -- calculates sideA, from angleA, andgleB, and sideC
    -- Formula follows:
    -- Given, Angles: A, B
    -- Given, Between: D
    -- PI - A - B = C
    -- {A,B,C} = L1
    -- D * sin({A,B}) / sin(C) = L2
    -- D = L2(3)
    -- return {L1, L2}
    sequence tmp, angles, sides
    if angleA[4] != angleB[4] or angleA[4] != sideC[4] or
            angleA[3] != angleB[3] or angleA[3] != sideC[3] or
            IsNegative(angleA[1]) or IsNegative(angleB[1]) or IsNegative(sideC[1]) then
        printf(1, "Error %d\n", 6)
        abort(1/0)
    end if
    tmp = GetPI(sideC[3], sideC[4])
    tmp = EunSubtract(tmp, angleA)
    tmp = EunSubtract(tmp, angleB)
    angles = {angleA, angleB, tmp}
    -- Law of Sines (https://www.mathsisfun.com/algebra/trig-solving-asa-triangles.html)
    tmp = EunDivide(sideC, EunSin(tmp))
    sides = {
        EunMultiply(tmp, EunSin(angleA)),
        EunMultiply(tmp, EunSin(angleB)),
        sideC
    }
    return {angles, sides}
end function


global function EunGetSide(Eun angleA, Eun oppositeB, Eun oppositeC)
    -- two sides (SAS), with angleA, find sideA
    -- Law of Cosines: (https://www.mathsisfun.com/algebra/trig-solving-sas-triangles.html)
    -- (a*a) = (b*b) + (c*c) - (2 * b * c * cos(A))
    sequence tmp
    if angleA[4] != oppositeB[4] or angleA[4] != oppositeC[4] or
            angleA[3] != oppositeB[3] or angleA[3] != oppositeC[3] or
            IsNegative(angleA[1]) or IsNegative(oppositeB[1]) or IsNegative(oppositeC[1]) then
        printf(1, "Error %d\n", 6)
        abort(1/0)
    end if
    tmp = EunCos(angleA)
    tmp = EunMultiply(EunMultiply(EunMultiply(oppositeB, oppositeC), tmp), {{2}, 0, angleA[3], angleA[4]})
    tmp = EunSubtract(EunAdd(EunSquared(oppositeB), EunSquared(oppositeC)), tmp)
    tmp = EunSquareRoot(tmp)
    if tmp[1] then
        printf(1, "Error, something went wrong, %d\n", 6)
        abort(1/0)
    end if
    return tmp[2]
end function

--NOTE: Work on EunGetAngle():

global function EunGetAngle(Eun angleB, object distanceBetween = 0, object oppositeB = 0, object oppositeA = 0)
    -- Get angleA, given: angleB, distanceBetween, and either opposite side B, or opposite side A.
    sequence tmp
    if sequence(oppositeB) and sequence(oppositeA) then
        if angleB[4] != oppositeA[4] or angleB[3] != oppositeA[3] or angleB[4] != oppositeB[4] or angleB[3] != oppositeB[3] or
                IsNegative(oppositeA[1]) or IsNegative(oppositeB[1]) then
            printf(1, "Error %d\n", 6)
            abort(1/0)
        end if
        -- sin(A)/a = sin(B)/b
        tmp = EunSin(angleB)
        tmp = EunMultiply(tmp, oppositeA)
        tmp = EunDivide(tmp, oppositeB)
        tmp = EunArcSin(tmp)
        return tmp
    end if
    if angleB[4] != distanceBetween[4] or angleB[3] != distanceBetween[3] or
            IsNegative(angleB[1]) or IsNegative(distanceBetween[1]) then
        printf(1, "Error %d\n", 6)
        abort(1/0)
    end if
    if atom(oppositeA) then
        if atom(oppositeB) then
            return 0
        else
            -- given oppositeB
            tmp = oppositeB
        end if
    else
        -- given oppositeA
        tmp = oppositeA
    end if
    if angleB[4] != tmp[4] or angleB[3] != tmp[3] or
            IsNegative(tmp[1]) then
        printf(1, "Error %d\n", 6)
        abort(1/0)
    end if
    tmp = EunSquareRoot(
        EunAdd({{-1}, 0, angleB[3], angleB[4]}, EunSquared(EunDivide(tmp, distanceBetween)))
    )
    if tmp[1] then
        printf(1, "Error, something went wrong, %d\n", 6)
        abort(1/0)
    end if
    tmp = tmp[2]
    if sequence(oppositeA) then
        tmp = EunMultiplicativeInverse(tmp)
    end if
    tmp = EunArcSin(EunMultiply(tmp, EunSin(angleB)))
    return tmp
end function


global function EunGetAngleSides(Eun oppositeA, Eun oppositeB, Eun oppositeC)
    -- Law of Cosines (angle version): cos(A) == (b*b + c*c - a*a)/(2*b*c)
    sequence tmp, squared, angles, sides
    if atom(oppositeA) or atom(oppositeB) or atom(oppositeC) then
        return 0
    end if
    if oppositeA[4] != oppositeB[4] or oppositeA[4] != oppositeC[4] or
            oppositeA[3] != oppositeB[3] or oppositeA[3] != oppositeC[3] or
            IsNegative(oppositeA[1]) or IsNegative(oppositeB[1]) or IsNegative(oppositeC[1]) then
        printf(1, "Error %d\n", 6)
        abort(1/0)
    end if
    sides = {oppositeA, oppositeB, oppositeC}
    squared = {EunSquared(sides[1]), EunSquared(sides[2]), EunSquared(sides[3])}
    angles = repeat(0, 3)
    for i = 1 to length(angles) do
        tmp = EunDivide(
            EunSubtract(EunAdd(squared[2], squared[3]), squared[1]),
            EunMultiply({{2}, 0, oppositeA[3], oppositeA[4]}, EunMultiply(sides[2], sides[3]))
        )
        angles[i] = EunArcCos(tmp)
        sides = rotate(sides)
        squared = rotate(squared)
    end for
    return angles
    --tmp = EunDivide(
    --    EunSubtract(EunAdd(EunSquared(oppositeB), EunSquared(oppositeC)), EunSquared(oppositeA)),
    --    EunMultiply({{2}, 0, oppositeA[3], oppositeA[4]}, EunMultiply(oppositeB, oppositeC))
    --)
    --tmp = EunArcCos(tmp)
    --return tmp
end function


global constant
    GT_OMIT = 0,
    GT_FIND = 1

global type threeObjects(sequence s)
    return length(s) = 3
end type

global function EunGenericTriangulation(threeObjects angles, threeObjects opposites)
    -- Returns {{return_code, angles}, {return_code, sides}}
    -- return_code is: -1 when it is done, 0 or higher when it did something (1 or higher when it needed to rotate).
    --
    -- Generic Triangulation function.
    -- Have one (1) or more GT_FIND variables, and omit variables using GT_OMIT.
    -- Angles are in radians; use "angles" and "opposites" to define any real triangle.
    --
    -- See also:
    -- (https://www.mathsisfun.com/algebra/trig-solving-practice.html)
    --
    -- AAA Triangle - Three Angles
    -- AAS Triangle - Two Angles and a Side not between
    -- ASA Triangle - Two Angles and a Side between
    -- SAS Triangle - Two Sides and an Angle between
    -- SSA Triangle - Two Sides and an Angle not between
    -- SSS Triangle - Three Sides

    integer rotateby1, rotateby2, flag
    object tmp

    rotateby1 = find(GT_FIND, angles) - 1
    if rotateby1 >= 0 then
        angles = rotate(angles, rotateby1)
        opposites = rotate(opposites, rotateby1)
        -- given values are sequences
        if sequence(angles[2]) then
            if sequence(angles[3]) then
                -- given, two angles (AAA, AAS, ASA)
                angles[1] = GetPI(angles[2][3], angles[2][4])
                angles[1] = EunSubtract(angles[1], angles[2])
                angles[1] = EunSubtract(angles[1], angles[3])
            else
                -- need opposites: (A, C) or (B, C) (SAS)
                angles[1] = EunGetAngle(angles[2], opposites[3], opposites[2], opposites[1])
                angles[1] = assign(angles[1], 7, EunSubtract(GetPI(angles[1][3], angles[1][4]), angles[1]))
            end if
        elsif sequence(angles[3]) then
            -- need opposites: (A, B) or (B, C) (SSA)
            angles[1] = EunGetAngle(angles[3], opposites[2], opposites[3], opposites[1])
            angles[1] = assign(angles[1], 7, EunSubtract(GetPI(angles[1][3], angles[1][4]), angles[1]))
        else
            -- no angles, only sides: (A, B, C) (SSS)
            angles = EunGetAngleSides(opposites[1], opposites[2], opposites[3])
        end if
    end if
    if rotateby1 > 0 then
        angles = rotate(angles, - (rotateby1))
        opposites = rotate(opposites, - (rotateby1))
    end if
    rotateby2 = find(GT_FIND, opposites) - 1
    if rotateby2 >= 0 then
        flag = 0
        angles = rotate(angles, rotateby2)
        opposites = rotate(opposites, rotateby2)
        -- given vales are sequences
        if sequence(opposites[2]) then
            if sequence(opposites[3]) then
                -- two sides (SAS), with angleA, find sideA
                -- Law of Cosines:
                -- (a*a) = (b*b) + (c*c) - (2 * b * c * cos(A))
                if atom(angles[1]) then
                    trace(1)
                    angles[1] = GT_FIND
                    tmp = EunGenericTriangulation(angles, opposites)
                    angles = tmp[1][2]
                    opposites = tmp[2][2]
                end if
                if sequence(angles[1]) then
                    opposites[1] = EunGetSide(angles[1], opposites[2], opposites[3])
                end if
            elsif sequence(angles[1]) and sequence(angles[3]) then
                -- one side (ASA)
                -- EunTriangulationASA(Eun angleA, Eun angleB, Eun sideC)
                angles = rotate(angles, 2)
                opposites = rotate(opposites, 2)
                rotateby2 += 2
                flag = 1
            end if
        elsif sequence(opposites[3]) and sequence(angles[1]) and sequence(angles[2]) then
            -- one side (ASA)
            -- EunTriangulationASA(Eun angleA, Eun angleB, Eun sideC)
            flag = 1
        end if
        if flag then
            tmp = EunTriangulationASA(angles[1], angles[2], opposites[3])
            angles = tmp[1]
            opposites = tmp[2]
        end if
    end if
    if rotateby2 > 0 then
        angles = rotate(angles, - (rotateby2))
        opposites = rotate(opposites, - (rotateby2))
    end if
    return {{rotateby1, angles}, {rotateby2, opposites}}
end function


--Begin: Incorrect Triangulation formula:
-- 
-- -- Triangulation using two (2) points, and the distance between.
-- 
-- -- Given: angle A, angle B, distance D (distance between angles A and B)
-- -- Find distance E and F, (from angle A and B), to intersect point.
-- -- C is a temporary value.
-- 
-- -- Proof:
-- -- NOTE: uses all positive numbers
-- --
-- -- define:
-- -- observer at point A, angle A from distance D
-- -- observer at point B, angle B from distance D
-- -- distance D between point A and point B
-- -- distance E coming from angle A
-- -- distance F coming from angle B
-- -- height G at right angles (tangent) to distance D
-- -- X^2 <=> X*X
-- --
-- -- sin(A) == G / E; sin(B) == G / F
-- -- G <=> E * sin(A) <=> F * sin(B)
-- -- divide one by the other, equalling value of one (1)
-- -- ratio: F / E == sin(A) / sin(B)
-- -- F == E * sin(A) / sin(B)
-- -- Pythagorean Theorem:
-- -- D^2 = E^2 + F^2
-- -- F == sqrt(D^2 - E^2) == E * sin(A) / sin(B)
-- -- D^2 == E^2 + (E * sin(A) / sin(B))^2
-- -- D^2 == E^2 + E^2 * (sin(A) / sin(B))^2
-- -- D^2 == E^2 * (1 + (sin(A) / sin(B))^2)
-- -- E == sqrt(D^2 / (1 + (sin(A) / sin(B))^2))
-- -- E == D * sqrt(1 / (1 + (sin(A) / sin(B))^2))
-- -- E == D / sqrt(1 + (sin(A) / sin(B))^2)
-- -- ratio inverted for "F":
-- -- F == D / sqrt(1 + (sin(B) / sin(A))^2)
-- --
-- -- End of Proof
-- 
-- global function EunTriangulation(Eun angleA, Eun angleB, Eun distance, WhichOnes whichOnes = 3)
--     Eun sa, sb
--     sequence s, tmp
--     integer mode
--     if angleA[4] != angleB[4] or angleA[4] != distance[4] or
--             angleA[3] != angleB[3] or angleA[3] != distance[3] or
--             IsNegative(angleA[1]) or IsNegative(angleB[1]) or IsNegative(distance[1]) then
--         printf(1, "Error %d\n", 6)
--         abort(1/0)
--     end if
--     mode = realMode
--     realMode = TRUE
--     sa = EunSin(angleA)
--     sb = EunSin(angleB)
--     s = {0, 0}
--     if and_bits(whichOnes, 1) then
--         tmp = EunSquareRoot(
--             EunMultiplicativeInverse(
--                 EunAdd({{1}, 0, angleA[3], angleA[4]}, EunSquared(EunDivide(sa, sb)))
--             )
--         )
--         if tmp[1] then
--             printf(1, "Error, something went wrong, %d\n", 6)
--             abort(1/0)
--         end if
--         s[1] = EunMultiply(distance, tmp[2])
--     end if
--     if and_bits(whichOnes, 2) then
--         tmp = EunSquareRoot(
--             EunMultiplicativeInverse(
--                 EunAdd({{1}, 0, angleA[3], angleA[4]}, EunSquared(EunDivide(sb, sa)))
--             )
--         )
--         if tmp[1] then
--             printf(1, "Error, something went wrong, %d\n", 6)
--             abort(1/0)
--         end if
--         s[2] = EunMultiply(distance, tmp[2])
--     end if
--     realMode = mode
--     return s -- {n1, n2}
-- end function
--
--End: Incorrect Triangulation formula.
