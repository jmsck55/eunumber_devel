-- Copyright James Cook


include ../../eunumber/array/Negate.e

include Complex.e


-- Negate the imaginary part of a Complex number
global function NegateImag(Complex a)
    a[IMAG][1] = Negate(a[IMAG][1])
    return a
end function

global function ComplexConjugate(Complex z)
    return NegateImag(z)
end function
