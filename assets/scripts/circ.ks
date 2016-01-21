//Set the ship to a known configuration
SAS off.
RCS on.
lights off.
lock throttle to 0. //Throttle is a decimal from 0.0 to 1.0
gear off.

DECLARE PARAMETER target_altitude.

set runmode to 1.
set orbit to ship:orbit.
set scale_step to 0.1.
set delta_v_scale_step to 0.01.

clearscreen.

until runmode = 0 {
        print "RUNMODE: " + runmode at (5,5).

        if runmode = 1 { // search for node position
                global node is node(time:seconds, 0, 0, 0).
                add node.

                until (abs(node:orbit:periapsis - orbit:periapsis) < 0.5) AND
                      (abs(node:orbit:apoapsis - orbit:apoapsis) < 0.5) {
                        set node:eta to node:eta + scale_step.
                        PRINT "DIFF PERIAPSIS: " + abs(node:orbit:periapsis - orbit:periapsis) at (5,10).
                        PRINT "DIFF APOAPSIS: " + abs(node:orbit:apoapsis - orbit:apoapsis) at (5,11).

                }
                set runmode to 2.
        }

        else if runmode = 2 { // burn to raise apoapsis
                if node:orbit:apoapsis < target_altitude {
                        local deltav is 0.
                        until (abs(node:orbit:apoapsis - target_altitude) < 10) {
                                print "ORBIT APOAPSIS: " + node:orbit:apoapsis at (5,13).
                                print "TARGET APOAPSIS: " + target_altitude at (5,14).
                                print "DIFF APOAPSIS: " + abs(node:orbit:apoapsis - target_altitude) at (5,15).
                                set deltav to deltav + delta_v_scale_step.
                                set node:prograde to deltav.
                                if deltav > 100 {
                                        break.
                                }
                        }
                }
                global node is node(time:seconds + node:eta + (node:orbit:period/2), 0, 0, 0).
                add node.
                set runmode to 3.
        }

        else if runmode = 3 { // burn to raise periapsis
                if node:orbit:periapsis < target_altitude {
                        local deltav is 0.
                        until (abs(node:orbit:periapsis - target_altitude) < 10) {
                                print "ORBIT APOAPSIS: " + node:orbit:periapsis at (5,13).
                                print "TARGET APOAPSIS: " + target_altitude at (5,14).
                                print "DIFF APOAPSIS: " + abs(node:orbit:periapsis - target_altitude) at (5,15).
                                set deltav to deltav + delta_v_scale_step.
                                set node:prograde to deltav.
                                if deltav > 100 {
                                        break.
                                }
                        }
                }
                set runmode to 0.
        }
}
