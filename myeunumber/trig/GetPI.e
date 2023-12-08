-- Copyright James Cook

-- PI functions:

-- GetPI, GetTwoPI, GetHalfPI, GetQuarterPI


include ../../eunumber/minieun/Common.e
include ../../eunumber/minieun/Defaults.e
include ../../eunumber/minieun/Eun.e
include ../../eunumber/minieun/AdjustRound.e
include ../../eunumber/minieun/Multiply.e
include EunArcTan.e


-- constant strPI =
-- "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989"
-- quarterPI = EunMultiply(ToEun(strPI, 10, length(strPI) - 1), NewEun({2, 5}, -1, length(strPI) - 1, 10))

global sequence quarterPI = {}

-- NOTE: To precalculate, put the largest value for targetLength first, then use the same radix for all your calculations, before switching to another radix.
-- You can also use the "SwapQuarterPI()" function below:

global function SwapQuarterPI(sequence s = quarterPI) -- SwapQuarterPI when changing radixes, then swap back when changing back.
    object oldvalue = quarterPI
    quarterPI = s
    return oldvalue
end function

global function GetQuarterPI(integer targetLength = defaultTargetLength, atom radix = defaultRadix,
        sequence config = {}, integer getAllLevel = NORMAL, PositiveInteger multBy = 1)
    sequence ret
    -- targetLength += adjustPrecision
    if (not length(quarterPI)) or (not length(quarterPI[1])) or
            (quarterPI[3] <= targetLength) or (quarterPI[4] != radix) then
        quarterPI = ArcTanExp({1}, 0, targetLength + 1, radix, config, NORMAL)
    end if
    if multBy = 1 then
        ret = quarterPI
    else
        object tmp = AdjustRound({multBy}, 0, targetLength, radix, CARRY_ADJUST, config, NORMAL)
        ret = AdjustRound(quarterPI[1], quarterPI[2], targetLength, radix, NO_SUBTRACT_ADJUST, config, TO_EXP)
        ret = MultiplyExp(ret[1], ret[2], tmp[1], tmp[2], targetLength, radix, CARRY_ADJUST, config, TO_EXP)
    end if
    ret = AdjustRound(ret[1], ret[2], targetLength, radix, NO_SUBTRACT_ADJUST, config, getAllLevel)
    return ret
end function

global function GetHalfPI(integer targetLength = defaultTargetLength, atom radix = defaultRadix,
        sequence config = {}, integer getAllLevel = NORMAL)
    return GetQuarterPI(targetLength, radix, config, getAllLevel, 2)
end function

global function GetPI(integer targetLength = defaultTargetLength, atom radix = defaultRadix,
        sequence config = {}, integer getAllLevel = NORMAL)
    return GetQuarterPI(targetLength, radix, config, getAllLevel, 4)
end function

global function GetTwoPI(integer targetLength = defaultTargetLength, atom radix = defaultRadix,
        sequence config = {}, integer getAllLevel = NORMAL)
    return GetQuarterPI(targetLength, radix, config, getAllLevel, 8)
end function

