-- Copyright James Cook
-- Matrix support functions of EuNumber.
-- include eunumber/MatrixFuncs.e

namespace matrixfuncs

include ../minieun/NanoSleep.e
include ../minieun/Eun.e
include ../minieun/Defaults.e
include EunAdd.e
include EunMultiply.e
include EunAdjustRound.e

-- Matrix functions:
--
-- global type matrix(sequence s)
-- global function NewMatrix(integer rows, integer cols)
-- global function GetMatrixRows(sequence a)
-- global function GetMatrixCols(sequence a)
-- global function MatrixMultiply(matrix a, matrix b) -- MatrixMultiplication
-- global function MatrixTransposition(matrix a)

-- Matrix functions, below, use "defaultRadix".

global type matrix(sequence s)
    integer lenRows = length(s)
    if lenRows then
        integer lenCols
        lenCols = length(s[1])
        for row = 1 to lenRows do
            if length(s[row]) != lenCols then
                return 0
            end if
            for col = 1 to lenCols do
                if not Eun(s[row][col]) or s[row][col][4] != defaultRadix then
                    return 0
                end if
ifdef not NO_SLEEP_OPTION then
                sleep(nanoSleep)
end ifdef
            end for
ifdef not NO_SLEEP_OPTION then
            sleep(nanoSleep)
end ifdef
        end for
        return 1
    end if
    return 0
end type

global function NewMatrix(integer rows, integer cols)
    return repeat(repeat(NewEun(), cols), rows)
end function

global function GetMatrixRows(sequence a)
    return length(a)
end function

global function GetMatrixCols(sequence a)
    if length(a) then
        return length(a[1])
    end if
    return 0
end function

global function MatrixMultiply(matrix a, matrix b, integer getAllLevel = NORMAL)
-- ret[i] =
-- {
--  a[i][k1] * b[k1][j1] + a[i][k2] * b[k2][j1],
--  a[i][k1] * b[k1][j2] + a[i][k2] * b[k2][j2],
--  a[i][k1] * b[k1][j3] + a[i][k2] * b[k2][j3],
--  a[i][k1] * b[k1][j4] + a[i][k2] * b[k2][j4]
-- }
-- row0 = ret[i]
-- row1 = a[i]
    integer rows, cols, len
    sequence row1, sum, ret
    -- Eun sum
    -- matrix ret
    len = GetMatrixRows(b)
    if GetMatrixCols(a) != len then
        puts(1, "Error(8):  In MyEuNumber, in MatrixMultiply(), column-row mix-match.\n  See file: ex.err\n")
        abort(1/0)
    end if
    rows = GetMatrixRows(a)
    cols = GetMatrixCols(b)
    ret = NewMatrix(rows, cols)
    for i = 1 to rows do -- rows of "a"
        row1 = a[i]
        for j = 1 to cols do -- cols of "b"
            sum = NewEun()
            for k = 1 to len do -- k is cols of "a", rows of "b"
                sum = EunAdd(sum, EunMultiply(row1[k], b[k][j], TO_EXP), TO_EXP)
ifdef not NO_SLEEP_OPTION then
                sleep(nanoSleep)
end ifdef
            end for
            ret[i][j] = EunAdjustRound(sum, 0, NO_SUBTRACT_ADJUST, getAllLevel)
ifdef not NO_SLEEP_OPTION then
            sleep(nanoSleep)
end ifdef
        end for
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return ret
end function

global function MatrixTransposition(matrix a)
    integer rows, cols
    sequence ret, tmp
    rows = GetMatrixRows(a)
    cols = GetMatrixCols(a)
    ret = NewMatrix(cols, rows)
    for row = 1 to rows do
        tmp = a[row]
        for col = 1 to cols do
            ret[col][row] = tmp[col]
ifdef not NO_SLEEP_OPTION then
            sleep(nanoSleep)
end ifdef
        end for
ifdef not NO_SLEEP_OPTION then
        sleep(nanoSleep)
end ifdef
    end for
    return ret
end function

-- See also:
-- https://www.purplemath.com/modules/mtrxmult3.htm

