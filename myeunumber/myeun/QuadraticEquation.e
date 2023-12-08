-- Copyright James Cook
-- QuadraticEquation.e

include ../../eunumber/minieun/Eun.e
include ../../eunumber/minieun/GetAll.e
include ../../eunumber/eun/EunAdd.e
include ../../eunumber/eun/EunNegate.e
include ../../eunumber/eun/EunMultiply.e
include ../../eunumber/eun/EunMultiplicativeInverse.e

include ../myeun/EunSquareRoot.e

include ../complex/Complex.e
include ../complex/ComplexMultiply.e

-- The Quadratic Equation
--
-- ax^2 + bx + c = 0
--
-- x = (-b +-sqrt(b^2 - 4ac)) / (2a)
--
-- x1 = (-b + sqrt(b^2 - 4ac)) / (2a)
-- x2 = (-b - sqrt(b^2 - 4ac)) / (2a)
--
-- 4*a*c
-- Negate
-- b*b
-- Subtract
-- sqrt
-- b
-- Negate
-- Add/Subtract
-- 2a
-- divide
--
-- two answers

global function EunQuadraticEquation(sequence a, sequence b, sequence c, integer getAllLevel = NORMAL)
    sequence n1, n2, n3, ans, tmp
    Complex c1, c2, c3
    sequence s, config
    integer targetLength
    --integer firstFlag = and_bits(getAllLevel, GET_ALL)
    integer lastFlag = and_bits(getAllLevel, TO_EXP)
    s = EunCheckAll({a, b, c}, getAllLevel)
    config = s[3]
    targetLength = s[2]
    s = s[1]
    a = s[1]
    b = s[2]
    c = s[3]
    ans = EunMultiply(a, c, GET_ALL)
    ans = EunMultiply({{4}, 0, a[3], a[4]}, ans, GET_ALL)
    ans = EunNegate(ans, GET_ALL)
    tmp = EunSquared(b, GET_ALL)
    ans = EunAdd(tmp, ans, GET_ALL)
    s = EunSquareRoot(ans, GET_ALL)
    tmp = EunNegate(b, GET_ALL)
    if s[1] then -- isImaginary, treat is as a Complex number
        -- Complex
        --here:
        c1 = NewComplex(tmp, s[2]) -- (-b) + ans * i
        c2 = NewComplex(tmp, s[3]) -- (-b) - ans * i
        tmp = EunMultiply({{2}, 0, a[3], a[4]}, a)
        n3 = EunMultiplicativeInverse(tmp)
        c3 = NewComplex(n3, {{}, 0, a[3], a[4]})
        c1 = ComplexMultiply(c1, c3)
        c2 = ComplexMultiply(c2, c3)
        return {c1, c2}
    else
        n1 = EunAdd(tmp, s[2], GET_ALL)
        n2 = EunAdd(tmp, s[3], GET_ALL)
        tmp = EunMultiply({{2}, 0, a[3], a[4]}, a, GET_ALL)
        tmp = EunMultiplicativeInverse(tmp, GET_ALL)
        n1 = EunMultiply(n1, tmp, lastFlag + GET_ALL)
        n2 = EunMultiply(n2, tmp, lastFlag + GET_ALL)
        return {n1, n2}
    end if
end function
