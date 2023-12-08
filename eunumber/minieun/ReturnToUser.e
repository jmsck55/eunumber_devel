-- Copyright James Cook
-- "Return to user" callback functions of EuNumber.

-- NOTE: It has to round, or not.

namespace returntouser

--ifdef WITHOUT_TRACE then
--without trace
--end ifdef

include AdjustRound.e
include Defaults.e
include CompareFuncs.e
include UserMisc.e

global integer abort_calculating = 0
public integer calculating = 0 -- FALSE

global procedure SetCalculatingStatus(integer falseToStopTrueToContinue)
    calculating = falseToStopTrueToContinue
end procedure

global function GetCalculatingStatus()
    return calculating
end function

global function HowComplete(sequence n1, integer exp1, sequence n2, integer exp2,
     integer start = 1, integer stop = -1)
    integer c, clength, cminlength
    c = CompareExp(n1, exp1, n2, exp2, stop, start) -- use default value for 5th (fith) argument.
    --if c = 0 and start > 1 then
    --    c = CompareExp(n1, exp1, n2, exp2)
    --end if
    clength = GetEqualLength() -- from CompareExp()
    cminlength = GetCompareMin() -- from CompareExp()
    return {clength + 1, cminlength, c}
end function


global function DefaultRTU(integer eunFunc, sequence hc, integer targetLength,
     sequence ret, sequence lookat, atom radix, sequence config)
    integer level -- 0, 1, or 2

--global sequence howComplete = {level = 0, ret, new_howComplete}
-- hc == {clength + 1, cminlength, compare() == -1 or 0 or 1}

    if not abort_calculating and length(hc) then
        if atom(hc[1]) then -- Eun number:
            ret = AdjustRound(ret[1], ret[2], targetLength, radix, NO_SUBTRACT_ADJUST, config)
            if length(hc) = 3 then
                hc = hc & 0
            end if
            level = max(hc[4], 1) -- continue loop
            --if level = 2 then -- optimization, may return bad results.
            --    level = 0
            --elsif length(lookat) >= 2 then
            if length(lookat) >= 2 then
                integer start = hc[1]
                -- Compare:
                hc = HowComplete(ret[1], ret[2], lookat[1], lookat[2], start) --, targetLength + 1)
                if hc[3] = 0 then
                    hc = HowComplete(ret[1], ret[2], lookat[1], lookat[2], 1, start - 1)
                    if hc[3] = 0 then --or hc[1] > targetLength + 1 then -- hc[1] = hc[2] then
                        if FOR_ACCURACY and level = 1 then
                            ret[3] = Ceil(ret[3] * accuracyMultiplyBy) -- ???
                            hc = {1, 0, {}}
                            level = 2 -- run one more calculation, should be caught by AdjustRound() above.
                        else
                            level = 0 -- return answer "ret"
                        end if
                    end if
                end if
            end if
        else -- Complex or multivariable number, such as: ComplexArcTanA()
            sequence s
            level = 0
            s = repeat(0, length(hc))
            for i = 1 to length(hc) do
                s[i] = DefaultRTU(eunFunc, hc[i], targetLength, ret[i], lookat[i], radix, config)
                level = level or s[i][1] -- max(level, s[i][1])
                ret[i] = s[i][2]
                hc[i] = s[i][3]
            end for
            return {level = 0, ret, hc}
        end if
    else
        level = 0
    end if
    return {level = 0, ret, hc & level}
end function

-- To use default method, just set: SetReturnToUserCallBack(-1)
-- Or, use the variable below:
global integer defaultRTU_id = -1 -- routine_id("DefaultRTU")

integer return_to_user_id = -1

global procedure SetReturnToUserCallBack(integer id)
    return_to_user_id = id
end procedure

global function GetReturnToUserCallBack()
    return return_to_user_id
end function

global function ReturnToUserCallBack(integer eunFunc, sequence a, integer targetLength,
     sequence ret, sequence lookat, atom radix, sequence config = {})
    object x
    if length(config) = 0 then
        config = NewConfiguration()
    end if
    ifdef USE_TASK_YIELD then
        if useTaskYield then
            task_yield()
        end if
    end ifdef
    if return_to_user_id > -1 then
        -- call_func(argument length==6) return value is {0, ret, a} to continue loop, {1, ret, a} to return answer.
        x = call_func(return_to_user_id, {eunFunc, a, targetLength, ret, lookat, radix, config}) -- pass 6 variables to the function
    else
    -- default is_equal() code:
        x = DefaultRTU(eunFunc, a, targetLength, ret, lookat, radix, config)
    end if
    return x
end function
