-- Copyright James Cook
-- "AdjustRound" functions of EuNumber.

namespace adjustround

ifdef WITHOUT_TRACE then
without trace
end ifdef

include ../array/Carry.e
include ../array/Subtract.e
include ../array/TrimZeros.e
include Common.e
include Defaults.e
include NanoSleep.e
include MultiTasking.e
include UserMisc.e
include Eun.e

-- TODO, test AdjustRound(), not done yet.

-- AdjustRound() is almost an array function, takes 4 arguments and options, returns 4 or 5 elements.

--here, look at "MultiplicativeInverse()" and what Proto member functions should return.

--global constant CARRY_ADJUST = 0, BORROW_ADJUST = 1, NO_SUBTRACT_ADJUST = 2, BORROW_ONLY = 3, AUTO_ADJUST = 4
-- isMixed:
-- CARRY_ADJUST: "only" do Carry() in Subtract().
-- BORROW_ADJUST: do "both" Carry() "and" Borrow() in Subtract(), default.
-- NO_SUBTRACT_ADJUST: "don't" call Subtract(), "don't" do either.
-- BORROW_ONLY: "only" do Borrow() in Subtract().
-- AUTO_ADJUST: automatically determine the type of adjust. Used in "AddExp()".

global function AdjustRound(sequence num, integer exponent, TargetLength targetLength, AtomRadix radix,
     FiveOptions isMixed = BORROW_ADJUST, sequence config = {}, integer getAllLevel = NORMAL)
    -- done.
    integer isIntegerMode, intModeFloat, moreTargetLen, isRoundZero, roundZeroExp,
        oldlen, roundTargetLength, rounded, isNeg, adjustAccuracy
    atom halfRadix, compareHalfRadix, f
    sequence ret --, roundedDigits
    ifdef USE_TASK_YIELD then
        if useTaskYield then
            task_yield()
        end if
    end ifdef
    if isMixed = AUTO_ADJUST then
        isMixed = BORROW_ADJUST
    end if
    if length(config) then
        isIntegerMode = GetIsIntegerMode1(config)
        intModeFloat = GetIntegerModeFloat1(config)
        moreTargetLen = GetMoreTargetLength1(config)
        isRoundZero = GetIsRoundToZero1(config)
        roundZeroExp = GetRoundToZeroExp1(config)
    else
        isIntegerMode = ROUND_TO_NEAREST_OPTION
        intModeFloat = integerModeFloat
        moreTargetLen = moreTargetLength
        isRoundZero = isRoundToZero
        roundZeroExp = roundToZeroExp
    end if
    if getAllLevel > 0 then
        targetLength = getAllLevel
    end if
    -- if not CheckLengthAndRadix(targetLength, radix) then
    --      puts(2, "Error, bad length and radix.\n")
    --      abort(1/0)
    -- end if
    if targetLength < 0 then
        abort(1/0) -- don't suppress error.
    end if
    oldlen = length(num)
    num = TrimLeadingZeros(num)
    if isMixed != NO_SUBTRACT_ADJUST then
        --adjustExponent()
        -- in Subtract, the first element of num cannot be a zero.
        num = Subtract(num, radix, isMixed)
        -- NOTE: Use Subtract() when there are both negative and positive numbers.
        -- otherwise, you can use Carry().
        num = TrimLeadingZeros(num)
    end if
    exponent += (length(num) - (oldlen))
    if getAllLevel = TO_EXP then -- return a 4th-element sequence, when (getAllLevel > 0) (it will getAllLevel rounding).
        -- You need a 4th-element sequence when passing values to "Func1Exp()" functions.
        -- getAllLevel should be (getAllLevel >= 1) before passing values to "Func1Exp()" functions.
        -- Use: AdjustRound(a,b,c,d,isMixed,config,1) to return a 4th-element sequence, to pass to "Func1Exp()" functions.
        -- Use: EunGetAllToExp(eun) to convert a 5th-element sequence to a 4th-element sequence.
        -- Use: "AdjustRound(a,b,c,d,isMixed==2,config,0)" or simply: "AdjustRound(a,b,c,d,isMixed==2,config)", to convert a 4th-element sequence to a 5th-element sequence.
        targetLength += moreTargetLen -- moreTargetLength usually equals 2 or 3.
    end if
    -- rounded = {}
    --if length(num) = 0 then
    --    ret = {{}, exponent, targetLength, radix, rounded}
    --    return ret
    --end if
    --if COMPRESS_LEAD then -- Use function, CompressLeadingDigit(), instead.
    --  f = num[1]
    --  if abs(f) <= COMPRESS_LEAD then
    --      num = num[2..$]
    --      f *= radix
    --      if length(num) then
    --          num[1] += f
    --      else
    --          num = {f}
    --      end if
    --      exponent -= 1
    --  end if
    --end if
    -- Round2: num, exponent, targetLength, radix
    -- Be careful when using ROUND_TO_NEAREST_OPTION and isRoundToZero together.
    roundTargetLength = targetLength
    if isIntegerMode then -- IntegerMode
        roundTargetLength = exponent + 1 + intModeFloat
        if roundTargetLength < 0 then
            roundTargetLength = 0
        end if
        if targetLength < roundTargetLength then
            targetLength = roundTargetLength
        end if
    end if
    if isRoundZero then
        if roundTargetLength then -- only if roundTargetLength is greater than zero, (roundTargetLength > 0)
            if roundZeroExp > exponent then
                roundTargetLength = 0
            end if
        end if
    end if
    if roundTargetLength < length(num) and roundTargetLength >= 0 then
        -- roundedDigits = {{0} & num[roundTargetLength + 1..$], exponent - roundTargetLength + 1}
        if getAllLevel = TO_EUN then
            -- skip round, save adjustAccuracy. It should be negative, or zero (0).
            targetLength = length(num)
            adjustAccuracy = roundTargetLength - targetLength -- New. adjustAccuracy looks better negative, -(moreTargetLen).
        elsif roundingMethod = ROUND_TRUNCATE or roundTargetLength = 0 then
            -- rounded = isNeg - (num[1] > 0) -- give the opposite of the sign
            num = num[1..roundTargetLength]
        else
            isNeg = num[1] < 0
            halfRadix = floor(radix / 2)
            f = num[roundTargetLength + 1]
            if isNeg then
                compareHalfRadix = - (halfRadix)
            else
                compareHalfRadix = halfRadix
            end if
            if integer(radix) and IsIntegerOdd(radix) then
                -- feature: support for odd radixes
                for i = roundTargetLength + 2 to length(num) do
                    if f != compareHalfRadix then
                        exit
                    end if
                    f = num[i]
ifdef not NO_SLEEP_OPTION then
                    sleep(nanoSleep)
end ifdef
                end for
            end if
            if f = compareHalfRadix then
                if length(num) > roundTargetLength then
                    f *= 2
                else
                    if roundingMethod = ROUND_EVEN then
                        halfRadix -= IsIntegerOdd(num[roundTargetLength])
                    elsif roundingMethod = ROUND_ODD then
                        halfRadix -= IsIntegerEven(num[roundTargetLength])
                    elsif roundingMethod = ROUND_ZERO then
                        f = 0
                    end if
                end if
            elsif roundingMethod = ROUND_INF then -- round towards plus(+) and minus(-) infinity
                halfRadix -= 1
            elsif roundingMethod = ROUND_POS_INF then -- round towards plus(+) infinity
                f += 1
            elsif roundingMethod = ROUND_NEG_INF then -- round towards minus(-) infinity
                f -= 1
            end if
            num = num[1..roundTargetLength]
            rounded = (f > halfRadix) - (f < - (halfRadix))
            if rounded then
                -- roundedDigits[1][1] = - (rounded)
                num[$] += rounded
                if rounded > 0 then
                    num = Carry(num, radix, TRUE) -- once = TRUE
                else
                    num = NegativeCarry(num, radix, TRUE) -- once = TRUE
                end if
                --if COMPRESS_LEAD then -- Use function, CompressLeadingDigit(), instead.
                --  f = num[1]
                --  if abs(f) <= COMPRESS_LEAD then
                --      num = num[2..$]
                --      f *= radix
                --      if length(num) then
                --          num[1] += f
                --      else
                --          num = {f}
                --      end if
                --      --exponent -= 1
                --  end if
                --end if
                oldlen = length(num) - (roundTargetLength)
                exponent += oldlen
                if isIntegerMode then -- if ROUND_TO_NEAREST_OPTION then
                    if targetLength < length(num) then
                        targetLength = length(num)
                    end if
                end if
            end if
        end if
    elsif getAllLevel = TO_EUN then
        adjustAccuracy = 0
        -- roundedDigits = {}
    end if
    if length(num) then
        num = TrimTrailingZeros(num)
        oldlen = length(num)
        num = TrimLeadingZeros(num)
        exponent += (length(num) - (oldlen))
    else
        exponent = 0
    end if
    if getAllLevel = TO_EUN then
        -- for Eun's:
        -- return adjustAccuracy as the 5th element
        ret = {num, exponent, targetLength, radix, adjustAccuracy}
    else
        ret = {num, exponent, targetLength, radix}
    end if
    return ret
end function

