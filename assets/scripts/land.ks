// land -- intersect with the surface, gently
//
// This program manages two of three primary concerns with landing a spacecraft
// on planetoid without an atmosphere. Namely,
//
//  * control of speed
//  * control of altitude
//
// Left entirely to the pilot is the choice of the landing site. To fascilitate
// landing, the craft is set to hover below 500 meters. Above this point
// throttle is kept at a pilot specified fixed-point, below hover-point the
// fix-point becomes altitude. RCS translation is intended to fine-tune the
// landing site, main-engine large adjustments.
//
// Paremters:
//   NONE
//
// Concerns:
//   * thrust-mode only controls vertical speed, horizontal speed is an exercise
//     for the pilot
//   * no guarantees are made about the landing; if the pilot tells the computer
//     to slam it into the ground, it'll slam it into the ground
//
// Procedure List:
//   1. Ensure that the craft is de-orbited
//   2. Before hover-mode, ensure that thrust is limited to 100m/s
//   2. Below 100 meters, extend gear
//   3. Below 50 meters ensure that acceleration is LESS than 12m/s
//   4. At altitude 5 meters, exit program (shutting down main engine)
//
// Example run:
//
//   > run land.

clearscreen.
SAS on.
RCS on.

set vT to -500. // In runmode 2 this is the height target. You're welcome.

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

// Note that in 'land' we use vT as an overloaded variable. This simplifies
// pilot controls--only one set of action groups are needed to make fix-point
// adjustments--at the expense of making this program potentially more
// confusing.
//
// All hail the mighty pilots, sitting in their tin cans.
on ag1 { set vT to vT -10. preserve. }.
on ag2 { set vT to vT - 1. preserve. }.
on ag3 { set vT to vT + 1. preserve. }.
on ag4 { set vT to vT +10. preserve. }.

on ag9 { set runmode to 0. }

// Though we overload vT we do _not_ overload the PIDs. To do so would be to
// risk Really Fun behaviour on changing modes.
set velocityPID to PID_init(0.05, 0.01, 0.1, 0, 1).
set hoverPID to PID_init(0.05, 0.01, 0.1, 0, 1).

until runmode = 0 {
        clearscreen.

        print "RUNMODE: " + runmode                                                    at (5,1).

        print "SHIP:ALTITUDE: " + ship:altitude                                        at (5,5).
        print "ALT:RADAR: " + alt:radar                                                at (5,6).

        print "TIME TO IMPACT: " + round(SQRT((2*alt:radar)/g),2)                      at (5,8).
        print "ZERO-V TIME: " + round(ship:verticalspeed/(ship:maxthrust/ship:mass),2) at (5,9).

        print "SHIP ACCEL: " + round(ship:maxthrust/ship:mass,2)                       at (5,11).
        print "VERTICAL SPEED: " + round(ship:verticalspeed,2)                         at (5,12).
        print "HORIZONTAL SPEED: " + round(ship:groundspeed,2)                         at (5,13).

        if runmode = 1 { // thrust mode
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
