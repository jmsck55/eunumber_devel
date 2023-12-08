-- Copyright James Cook
-- Common functions for EuNumber.

namespace common

ifdef WITHOUT_TRACE then
without trace
end ifdef

include MathConst.e

global constant TRUE = 1, FALSE = 0

global type Bool(integer i)
    return i = FALSE or i = TRUE
end type

global constant CARRY_ADJUST = 0, BORROW_ADJUST = 1, NO_SUBTRACT_ADJUST = 2, BORROW_ONLY = 3, AUTO_ADJUST = 4
-- isMixed:
-- CARRY_ADJUST: "only" do Carry() in Subtract().
-- BORROW_ADJUST: do "both" Carry() "and" Borrow() in Subtract(), default.
-- NO_SUBTRACT_ADJUST: "don't" call Subtract(), "don't" do either.
-- BORROW_ONLY: "only" do Borrow() in Subtract().
-- AUTO_ADJUST: automatically determine the type of adjust. Used in "AddExp()".

global constant NORMAL = 0, TO_EXP = -1, TO_EUN = -2, LOSSLESS = -2 -- To be passed to "AdjustRound()"
-- TO_EXP adds to targetLength and rounds in AdjustRound(), and returns a 4th element sequence, storing more accuracy and increasing targetLength.
-- TO_EUN is lossless, and returns a 5th element sequence.
-- NORMAL rounds normally, and looses extended accuracy.

-- Use TO_EXP or NORMAL between calls using TO_EUN, to shorten the extended accuracy.

-- Functions:

global function IsIntegerOdd(integer i)
    return remainder(i, 2) and 1
end function

global function IsIntegerEven(integer i)
    return not IsIntegerOdd(i)
end function

global function IsPositiveOdd(PositiveInteger i)
    return and_bits(i, 1)
end function

global function IsPositiveEven(PositiveInteger i)
    return and_bits(i, 0)
end function

global function IsNegative(sequence numArray)
    if length(numArray) then
        return numArray[1] < 0
    end if
    return 0 -- zero is not negative.
end function

global function IsPositive(sequence numArray)
    if length(numArray) then
        return numArray[1] >= 0
    end if
    return 1 -- zero is positive.
end function

-- Rounding modes:

global constant ROUND_INF = 1 -- Round towards +infinity or -infinity, (positive or negative infinity)
global constant ROUND_ZERO = 2 -- Round towards zero
global constant ROUND_TRUNCATE = 3 -- Don't round, truncate
global constant ROUND_POS_INF = 4 -- Round towards positive +infinity
global constant ROUND_NEG_INF = 5 -- Round towards negative -infinity
-- round even:
global constant ROUND_EVEN = 6 -- Round making number even on halfRadix
-- round odd:
global constant ROUND_ODD = 7 -- Round making number odd on halfRadix

global constant ROUND_AWAY_FROM_ZERO = ROUND_INF
global constant ROUND_TOWARDS_ZERO = ROUND_ZERO
global constant ROUND_TOWARDS_NEGATIVE_INFINITY = ROUND_NEG_INF
global constant ROUND_TOWARDS_POSITIVE_INFINITY = ROUND_POS_INF

global constant ROUND_DOWN = ROUND_NEG_INF -- Round downward.
global constant ROUND_UP = ROUND_POS_INF -- Round upward.

type Round2(integer i)
    return i >= 1 and i <= 7
end type

-- global for "doFile.ex":
global Round2 roundingMethod = ROUND_INF -- or you could try: ROUND_INF or any other roundingMethod method

global procedure SetRound(Round2 i)
    roundingMethod = i
end procedure

global function GetRound()
    return roundingMethod
end function

-- Types:

global type PositiveInteger(integer i)
    return i >= 0
end type

global type NegativeInteger(integer i)
    return i <= 0
end type

global type PositiveScalar(integer i)
    return i >= 2
end type

global type NegativeScalar(integer i)
    return i <= -2
end type

global type PositiveOption(integer i)
    return i >= -1
end type

global type ThreeOptions(integer i)
    return i >= 0 and i <= 2
end type

global type FourOptions(integer i)
    return i >= 0 and i <= 3
end type    

global type FiveOptions(integer i)
    return i >= 0 and i <= 4
end type    

global type WhichOnes(integer i)
    return i >= 1 and i <= 3
end type

global type PositiveAtom(atom a)
    return a >= 0.0
end type

global type NegativeAtom(atom a)
    return a <= 0.0
end type


global constant MIN_TARGETLENGTH = 0 -- 2 to 4

global type TargetLength(integer i)
    return i >= MIN_TARGETLENGTH
end type


ifdef USE_ATOM_RADIX then

    global type PositiveDigit(atom a)
        return a >= 0.0
    end type
    
    global type NegativeDigit(atom a)
        return a <= 0.0
    end type

    global type AtomRadix(atom a)
        ifdef USE_SMALL_RADIX then
            return a >= 1.001 and a <= DOUBLE_INT_MAX -- must be larger than 1.0
        elsedef
            return a >= 2 and a <= DOUBLE_INT_MAX -- must be 2.0 or larger
        end ifdef
    end type

elsedef

    global type PositiveDigit(integer i)
        return i >= 0
    end type

    global type NegativeDigit(integer i)
        return i <= 0
    end type

    global type AtomRadix(integer i)
        return i >= 2 and i <= INT_MAX
    end type

end ifdef
