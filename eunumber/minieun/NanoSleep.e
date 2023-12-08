-- Copyright James Cook
-- nanosleep.e functions for EuNumber.

-- NanoSleep support for loops:

namespace nanosleep

ifdef WITHOUT_TRACE then
without trace
end ifdef

constant
    M_ALLOW_BREAK = 42,
	M_CHECK_BREAK = 43,
    M_SLEEP = 64

type boolean(integer b)
    return b = 0 or b = 1
end type

global procedure allow_break(boolean b)
-- If b is TRUE then allow control-c/control-break to
-- terminate the program. If b is FALSE then don't allow it.
-- Initially they *will* terminate the program, but only when it
-- tries to read input from the keyboard.
    machine_proc(M_ALLOW_BREAK, b)
end procedure

global function check_break()
-- returns the number of times that control-c or control-break
-- were pressed since the last time check_break() was called
    return machine_func(M_CHECK_BREAK, 0)
end function


-- NanoSleep support:

ifdef UNIX then
    -- don't run LINUX computers too hot:
    global atom nanoSleep = 2/1000000000
elsedef
    global atom nanoSleep = -1 -- Windows doesn't need to use sleep(nanoSleep)
end ifdef

global procedure SetNanoSleep(atom a)
    nanoSleep = a
end procedure

global function GetNanoSleep()
    return nanoSleep
end function

allow_break(0)

global procedure sleep(atom s)
-- go to sleep for t seconds
-- allowing other processes to run
    if check_break() then
        abort(1/0)
    end if
ifdef USE_TASK_YIELD then
    if s >= 0 then
        atom t = time()
        task_yield()
        t = time() - t
        if t < s then
            machine_proc(M_SLEEP, s - t)
        end if
    else
        task_yield()
    end if
elsedef
    if s >= 0 then
        machine_proc(M_SLEEP, s)
    end if
end ifdef
end procedure
