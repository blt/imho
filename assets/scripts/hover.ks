clearscreen.
SAS on.
RCS on.

set seekAlt to round(ship:altitude).

copy PID from 0.
run PID.

on ag1 { set seekAlt to seekAlt -10. preserve. }.
on ag2 { set seekAlt to seekAlt - 1. preserve. }.
on ag3 { set seekAlt to seekAlt + 1. preserve. }.
on ag4 { set seekAlt to seekAlt +10. preserve. }.

on ag9 { set runmode to 0. }

set ship:control:pilotmainthrottle to 0.

set hoverPID to PID_init(0.05, 0.01, 0.1, 0, 1).

lock throttle to 1.
stage.

set runmode to 1.
until runmode = 0 {
        clearscreen.
        print "SEEK ALTITUDE: " + seekAlt at (5,3).
        print "ALT:RADAR: " + alt:radar at (5,4).
        print "SHIP:ALTITUDE: " + ship:altitude at (5,5).

        set TVAL to PID_seek(hoverPID, seekAlt, ship:altitude).
        lock throttle to TVAL.

        wait 0.001.
}.

set ship:control:pilotmainthrottle to throttle.
