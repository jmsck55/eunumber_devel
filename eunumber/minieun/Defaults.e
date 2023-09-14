-- Copyright James Cook
-- Default variables and functions of EuNumber.
-- include eunumber/Defaults.e

namespace defaults

include Common.e

-- Defaulted values, and the routines to retrieve them ("get") or modify them ("set").

global TargetLength defaultTargetLength = 70 -- 70 * 3 = 210 (I tried to keep it under 212)
global AtomRadix defaultRadix = 10 -- or 11 for 10% more accuracy. 10 or 11 is good for everything from 16-bit shorts, to 32-bit ints, to 64-bit long longs.
global PositiveAtom calculationSpeed = 0 -- floor(defaultTargetLength / 3) -- can be 0 or from 1 to targetLength
global Bool isRoundToZero = TRUE -- make TRUE to allow rounding small numbers (infinitesimals) to zero, change roundToZeroExp when using this option.
global integer roundToZeroExp = -(defaultTargetLength) -- the exponent for rounding to zero.
global PositiveAtom accuracyMultiplyBy = 1 -- 4 / 3 -- one third more. Should be between 1 and 2. Used in ReturnToUser.e
global Bool FOR_ACCURACY = FALSE -- TRUE -- TRUE for more accurate calculations, change to FALSE for faster calculations

global procedure SetForAccuracy(Bool i)
    FOR_ACCURACY = i
end procedure

global function GetForAccuracy()
    return FOR_ACCURACY
end function

global procedure SetAccuracyMultiplyBy(PositiveAtom a)
    accuracyMultiplyBy = a
end procedure

global function GetAccuracyMultiplyBy()
    return accuracyMultiplyBy
end function

-- For Integer Mode:
global Bool ROUND_TO_NEAREST_OPTION = FALSE -- Round to nearest whole number (Eun integer), true or false
global integer integerModeFloat = 0 -- usually, integerModeFloat is positive >= 0, (or it could be negative < 0), it is the number of decimal points in IntegerMode.

global procedure SetDefaultTargetLength(PositiveScalar i)
    defaultTargetLength = i
end procedure

global function GetDefaultTargetLength()
    return defaultTargetLength
end function

global procedure SetDefaultRadix(AtomRadix i)
    defaultRadix = i
end procedure

global function GetDefaultRadix()
    return defaultRadix
end function

global type CalcSpeedType(atom speed)
    return speed = 0.0 or speed >= 1.0
end type

global procedure SetCalcSpeed(CalcSpeedType speed)
    calculationSpeed = speed
end procedure

global function GetCalcSpeed()
    return calculationSpeed
end function

global procedure SetIsRoundToZero(Bool i)
    isRoundToZero = i
end procedure

global function GetIsRoundToZero()
    return isRoundToZero
end function

global procedure SetRoundToZeroExp(integer i)
    roundToZeroExp = i
end procedure

global function GetRoundToZeroExp()
    return roundToZeroExp
end function

global procedure SetRoundToNearestOption(Bool isIntegerMode)
    ROUND_TO_NEAREST_OPTION = isIntegerMode
end procedure

global function GetRoundToNearestOption()
    return ROUND_TO_NEAREST_OPTION
end function

global procedure IntegerModeOn()
    ROUND_TO_NEAREST_OPTION = TRUE
end procedure

global procedure IntegerModeOff()
    ROUND_TO_NEAREST_OPTION = FALSE
end procedure

-- Sets or gets the number of decimal places after an IntegerMode floating point number:

global procedure SetIntegerModeFloat(integer i)
    integerModeFloat = i
end procedure

global function GetIntegerModeFloat()
    return integerModeFloat
end function


