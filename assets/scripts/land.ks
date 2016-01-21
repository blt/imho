clearscreen.
SAS on.
RCS on.

set vT to -100. // In runmode 2 this is the height target.
                // You're welcome.

copy PID from 0.
run PID.

function gravity_accel {
        declare local GM to ship:body:mu.
        declare local R to (body:radius + ship:altitude).
        declare local g to GM/(R^2).
        return g.
}.

set g to gravity_accel().

set runmode to 1.

on ag1 { set vT to vT -10. preserve. }.
on ag2 { set vT to vT - 1. preserve. }.
on ag3 { set vT to vT + 1. preserve. }.
on ag4 { set vT to vT +10. preserve. }.

on ag9 { set runmode to 0. }

set ship:control:pilotmainthrottle to 0.

set velocityPID to PID_init(0.05, 0.01, 0.1, 0, 1).
set hoverPID to PID_init(0.05, 0.01, 0.1, 0, 1).

until runmode = 0 {
        clearscreen.

        print "SHIP:ALTITUDE: " + ship:altitude at (5,5).
        print "ALT:RADAR: " + alt:radar at (5,6).

        print "TIME TO IMPACT: " + round(SQRT((2*alt:radar)/g),2) at (5,8).
        print "ZERO-V TIME: " + round(ship:verticalspeed/(ship:maxthrust/ship:mass),2) at (5,9).

        print "SHIP ACCEL: " + round(ship:maxthrust/ship:mass,2) at (5,11).
        print "VERTICAL SPEED: " + round(ship:verticalspeed,2) at (5,12).
        print "HORIZONTAL SPEED: " + round(ship:groundspeed,2) at (5,13).

        if runmode = 1 { // thrust controlled descent
                print "THROTTLE TARGET: " + vT at (5,3).
                set tgt to PID_seek(velocityPID, vT, ship:verticalspeed).
                lock throttle to tgt.

                if alt:radar < 500 {
                        set vT to 500.
                        set runmode to 2.
                }
        }

        else if runmode = 2 { // hover mode
                print "HEIGHT TARGET: " + vT at (5,3).
                set tgt to PID_seek(hoverPID, vT, ALT:RADAR).
                lock throttle to tgt.
        }

        wait 0.01.
}.

set ship:control:pilotmainthrottle to 0.
