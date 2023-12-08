-- Copyright James Cook
-- Eun datatype functions of EuNumber.
-- done.

namespace euntype

ifdef WITHOUT_TRACE then
without trace
end ifdef

include Common.e
include Defaults.e
include MathConst.e
include UserMisc.e

-- Make sure our lengths and radixes are within safe limits for multiplication and carry.

global function GetMaxLengthForRadix(atom radix)
    atom d
    d = radix - 1
    return floor(INT_MAX / (d * d * 2))
end function

global function GetMaxRadixForLength(integer len)
    return sqrt(INT_MAX / (len * 2)) + 1
end function

global function CheckLengthAndRadix(integer len, atom radix)
    integer maxlen
    maxlen = GetMaxLengthForRadix(radix)
    return len <= maxlen
end function

global type Eun(object x)
    if sequence(x) then
        if length(x) >= 4 and length(x) <= 6 then
        -- length can be either 4, 5, or 6
            if integer(x[2]) then -- exponent, leading digit is muliplied by radix raised to the power of exponent
            if TargetLength(x[3]) then -- targetLength
            if (sequence(x[1]) and length(x[1]) <= x[3]) or x[1] = 1 or x[1] = -1 then
            if AtomRadix(x[4]) then -- radix
                if length(x) = 4 then
                    return TRUE
                end if
            if NegativeInteger(x[5]) then -- New: adjustAccuracy <= 0
                if length(x) = 5 then
                    return TRUE
                end if
            if sequence(x[6]) then -- configuration
                if length(x) = 6 then
                    return TRUE
                end if
            end if
            end if
            end if
            end if
            end if
            end if
        end if
    end if
    return FALSE
end type

-- Eun (type)
-- An Eun is:
-- [1] -- numArray
-- [2] -- exponent
-- [3] -- targetLength
-- [4] -- radix
-- [5] -- New: adjustAccuracy <= 0
-- [6] -- configuration
-- configuration: (library internals, use supplied functions to set/get these values)

-- [1] {moreTargetLength, defaultTargetLength}
-- [2] {defaultRadix, defaultPrecision}
-- [3] {isRoundToZero (true or false), roundToZeroExp} -- get zeros==true, or get infinitesimals==false
-- [4] {ROUND_TO_NEAREST_OPTION (true or false), integerModeFloat}
-- [5] {roundingMethod, multMoreAccuracy} -- rounding method, and multMoreAccuracy (0 or higher)

-- Optional: [i] FOR_ACCURACY (true or false)
-- configuration is placed at the end of the "Eun", currently, element, [6].
-- Have functions set these values.
-- Allow to copy to another "Eun".
--here, impliment functions that set/get these variables.

-- Access Members

global function GetNumArray(Eun a)
    return a[1]
end function

global function GetExponent(Eun a)
    return a[2]
end function

global function GetTargetLength(Eun a)
    return a[3]
end function

global function GetRadix(Eun a)
    return a[4]
end function

global function GetActualTargetLength(Eun a)
    integer targetLen = a[3]
    if length(a) >= 5 then
        targetLen += a[5] -- New: adjustAccuracy <= 0
    end if
    return targetLen -- returns actual targetLength.
end function

global integer myTargetLength = 0
global atom myRadix = 0
global integer myMoreTargetLength = 0

global function NewConfiguration()
-- [1] {moreTargetLength, defaultTargetLength}
-- [2] {defaultRadix, defaultPrecision}
-- [3] {isRoundToZero (true or false), roundToZeroExp} -- get zeros==true, or get infinitesimals==false
-- [4] {ROUND_TO_NEAREST_OPTION (true or false), integerModeFloat}
-- [5] {roundingMethod, multMoreAccuracy} -- rounding method, and multMoreAccuracy (0 or higher)
    if myTargetLength != defaultTargetLength or myRadix != defaultRadix then
        if isRoundToZero then
            roundToZeroExp = -(defaultTargetLength)
        end if
        myTargetLength = defaultTargetLength
        myRadix = defaultRadix
        myMoreTargetLength = Ceil(log(defaultTargetLength) / log(defaultRadix))
    end if
    return {
        {myMoreTargetLength, defaultTargetLength},
        {defaultRadix, defaultPrecision},
        {isRoundToZero, roundToZeroExp},
        {ROUND_TO_NEAREST_OPTION, integerModeFloat},
        {roundingMethod, defaultMultMoreAccuracy}
    }
end function

global sequence defaultConfiguration = {}

global function GetDefaultConfiguration()
    sequence config = NewConfiguration()
    if not equal(config, defaultConfiguration) then
        defaultConfiguration = config
    end if
    return defaultConfiguration
end function

global function GetConfiguration1(sequence s, integer index = 0, integer sub = 0)
    if Eun(s) then
        if length(s) < 6 then
            s = GetDefaultConfiguration()
        else
            s = s[6]
        end if
    end if
    if index then
        s = s[index]
        if sub then
            return s[sub]
        end if
    end if
    return s
end function

global function GetMoreTargetLength1(sequence a)
    return GetConfiguration1(a, 1, 1)
end function
global function GetDefaultTargetLength1(sequence a)
    return GetConfiguration1(a, 1, 2)
end function
global function GetDefaultRadix1(sequence a)
    return GetConfiguration1(a, 2, 1)
end function
global function GetDefaultPrecision1(sequence a)
    return GetConfiguration1(a, 2, 2)
end function
global function GetIsRoundToZero1(sequence a)
    return GetConfiguration1(a, 3, 1)
end function
global function GetRoundToZeroExp1(sequence a)
    return GetConfiguration1(a, 3, 2)
end function
global function GetIsIntegerMode1(sequence a)
    return GetConfiguration1(a, 4, 1)
end function
global function GetIntegerModeFloat1(sequence a)
    return GetConfiguration1(a, 4, 2)
end function
global function GetRoundingMethod1(sequence a)
    return GetConfiguration1(a, 5, 1)
end function
global function GetMultMoreAccuracy1(sequence a)
    return GetConfiguration1(a, 5, 2)
end function

-- NewEun() function:

-- Use RoundFloat() and EunRoundDigits() if you are using a Double (non-Integer) for Radix.

global function RoundFloat(object a, integer correction = 4)
    return Round(a, power(2, 53 - correction))
end function

global function EunRoundDigits(Eun a, integer correction = 5 - floor(log(a[4]) / logTwo))
    a[1] = RoundFloat(a[1], correction)
    return a
end function

-- Set precision:

global atom previousRadix = 0
global atom previousLogRadix = 0

global function PrecisionToTargetLength(integer prec, atom radix = defaultRadix)
    -- returns targetLength
    if previousRadix != radix then
        previousLogRadix = log(radix)
    end if
    return floor(prec * logTwo / previousLogRadix) + 1
    -- return Ceil(prec * logTwo / log(radix))
end function

global function SetPrecision(Eun n1, integer prec)
    integer targetLength
    targetLength = PrecisionToTargetLength(prec, n1[4])
    n1[3] = targetLength
    n1[6][2][2] = prec
    return n1
end function

global Bool is_round_array = TRUE

global procedure SetIsRoundArray(integer i)
    is_round_array = i
end procedure

global function GetIsRoundArray()
    return is_round_array
end function

global function NewEun(
            sequence num = {},
            integer exp = 0,
            integer targetLength = defaultTargetLength,
            atom radix = defaultRadix,
            integer adjustAccuracy = 0,
            sequence configuration = {}
        )
    if is_round_array then
        if not integer(radix) then
            num = RoundFloat(num)
        end if
    end if
    Eun ret -- does type checking.
    if length(configuration) then
        if GetDefaultPrecision1(configuration) then -- precision variable
            targetLength = PrecisionToTargetLength(GetDefaultPrecision1(configuration), radix)
            adjustAccuracy = -(MoreTargetLengthFormula(targetLength, radix)) -- adjustAccuracy is negative.
            targetLength -= adjustAccuracy -- adds accuracy to targetLength
        end if
        ret = {num, exp, targetLength, radix, adjustAccuracy, configuration}
    elsif adjustAccuracy then
        ret = {num, exp, targetLength, radix, adjustAccuracy}
    else
        ret = {num, exp, targetLength, radix}
    end if
    return ret
end function

-- Member functions

-- See also files and functions beginning with "Eun".


--global function IsProperLengthAndRadix(integer targetLength = defaultTargetLength, atom radix = defaultRadix)
--  if ROUND_TO_NEAREST_OPTION then
--      targetLength += adjustRound
--  else
--      targetLength -= adjustRound
--  end if
--  return (targetLength * power(radix - 1, 3) <= DOUBLE_INT_MAX)
--end function
