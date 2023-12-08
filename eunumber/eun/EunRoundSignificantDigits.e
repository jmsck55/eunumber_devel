-- Copyright James Cook

include ../minieun/Eun.e
include ../minieun/Common.e
include ../minieun/Defaults.e
include ../minieun/AdjustRound.e
include ../minieun/GetAll.e

-- EunRoundSignificantDigits:

global function EunRoundSig(sequence n1, integer sigDigits = defaultTargetLength, integer getAllLevel = NORMAL)
    Eun test = n1
    sequence config, tmp
    config = GetConfiguration1(n1)
    if sigDigits < MIN_TARGETLENGTH then
        config[3] = {TRUE, n1[2] + 1 - sigDigits} --here, what should this option be?
        sigDigits = MIN_TARGETLENGTH
    end if
    tmp = AdjustRound(n1[1], n1[2], sigDigits, n1[4], NO_SUBTRACT_ADJUST, config, getAllLevel)
    tmp = assign(tmp, 6, GetConfiguration1(n1))
    return tmp
end function

global function EunRoundSignificantDigits(Eun n1, PositiveInteger sigDigits = defaultTargetLength, integer getAllLevel = NORMAL)
    return EunRoundSig(n1, sigDigits, getAllLevel)
end function
