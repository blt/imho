clearscreen.
SAS on.
RCS on.

set vT to round(ship:verticalspeed * 0.90).

copy PID from 0.
run PID.

function gravity_accel {
        declare local GM to ship:body:mu.
        declare local R to (body:radius + ship:altitude).
        declare local g to GM/(R^2).
        return g.
}.

set g to gravity_accel().

on ag1 { set vT to vT -10. preserve. }.
on ag2 { set vT to vT - 1. preserve. }.
on ag3 { set vT to vT + 1. preserve. }.
on ag4 { set vT to vT +10. preserve. }.

set ship:control:pilotmainthrottle to 0.

set hoverPID to PID_init(0.05, 0.01, 0.1, 0, 1).

set runmode to 1.
until runmode = 0 {
        clearscreen.

        print "THROTTLE: " + vT at (5,3).

        print "SHIP:ALTITUDE: " + ship:altitude at (5,5).
        print "ALT:RADAR: " + alt:radar at (5,6).

        print "TIME TO IMPACT: " + round(SQRT((2*alt:radar)/g),2) at (5,8).
        print "ZERO-V TIME: " + round(ship:verticalspeed/(ship:maxthrust/ship:mass),2) at (5,9).

        print "SHIP ACCEL: " + round(ship:maxthrust/ship:mass,2) at (5,11).
        print "VERTICAL SPEED: " + round(ship:verticalspeed,2) at (5,12).
        print "HORIZONTAL SPEED: " + round(ship:groundspeed,2) at (5,13).

        set TVAL to PID_seek(hoverPID, vT, ship:verticalspeed).
        lock throttle to TVAL.

        if alt:radar < 15 {
                set runmode to 0.
        }

        wait 0.001.
}.

set ship:control:pilotmainthrottle to 0.
