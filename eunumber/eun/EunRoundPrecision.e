-- Copyright James Cook

include ../minieun/Eun.e
include ../minieun/ConvertExp.e
include ../minieun/AdjustRound.e
include ../minieun/GetAll.e

-- EunRoundPrecision
global function EunRoundPrecision(sequence a, integer prec = 0, integer getAllLevel = NORMAL)
    Eun test = a
    sequence b, config
    config = GetConfiguration1(a)
    if not prec then
        prec = GetDefaultPrecision1(config)
        if not prec then
            return a
        end if
    end if
    b = EunConvert(a, 2, prec, TO_EUN) -- TO_EUN means lossless
    b = EunConvert(b, a[4], PrecisionToTargetLength(prec, a[4]), getAllLevel)
    config[2] = {a[4], prec}
    b = NewEun(b[1], b[2], b[3], b[4], b[5], config)
    return b
end function
