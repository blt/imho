//Set the ship to a known configuration
SAS on.
RCS off.
lights off.
lock throttle to 0. //Throttle is a decimal from 0.0 to 1.0
gear off.

clearscreen.

// WARNING: This does _not_ calculate a free-return orbit! Resulting orbit may
// not even be in Kerbin's SOI, let alone re-intercept with Kerbin's atmosphere.
//
// WARNING: Maneuver node delta-v is _not_ checked against craft delta-v.
//
// FUN FACT: If target periapsis is < 1000 resulting orbit may intercept munar
// regolith.
//
// RUDE SURPRISE: Transfers from Mun to Kerbin do _not_ work.

declare parameter target,target_periapsis.
SET step TO 0.001.

set runmode to 1.
on ag9 { set runmode to 0. }

until runmode = 0 {

        if runmode = 1 {
                SET ship_radius to SHIP:OBT:SEMIMAJORAXIS.
                // wen want to get into to soi but not into the planet target
                SET tgt_radius to (target:OBT:SEMIMAJORAXIS - target:RADIUS   - target_periapsis -(target:SOIRADIUS/10) ).

                // Hohmann Transfer Time
                SET transfer_time to constant():pi * sqrt((((ship_radius + tgt_radius)^3)/(8*target:BODY:MU))).
                SET phase_angle to (180*(1-(sqrt(((ship_radius + tgt_radius)/(2*tgt_radius))^3)))).
                SET actual_angle to mod(360 + target:LONGITUDE - SHIP:LONGITUDE,360) .
                SET d_angle to (mod(360 + actual_angle - phase_angle,360)).

                SET ship_ang to  360/SHIP:OBT:PERIOD.
                SET tgt_ang to  360/TARGET:OBT:PERIOD.
                SET d_ang to ship_ang - tgt_ang.
                SET d_time to d_angle/d_ang.

                SET my_dV to sqrt (target:BODY:MU/ship_radius) * (sqrt((2* tgt_radius)/(ship_radius + tgt_radius)) - 1).

                SET ht_node TO NODE(time:seconds+d_time, 0, 0, my_dV).
                ADD ht_node.

                SET tgt_incl to 0.
                lock current_periapsis to ORBITAT(SHIP,time+transfer_time):PERIAPSIS.
                lock current_inclination to ORBITAT(SHIP,time+transfer_time):INCLINATION.

                set runmode to 2.
        }

        else if runmode = 2 { // adjust node
                if (ht_node:ETA < 60) {
                        print "WARNING: SHORT ETA" at (5,20).
                        print "COASTING 1 SECONDS" at (5,21).
                        REMOVE ht_node.
                        wait 1.
                        set runmode to 1.
                } else {
                        set runmode to 3.
                }
        }


        else if runmode = 3 {
                set loops to 0.
                until (abs(current_periapsis - target_periapsis) < 1000)
                      AND (current_inclination > tgt_incl) {
                              if current_inclination < 90 {
                                      if current_periapsis < target_periapsis  {
			                      set ht_node:PROGRADE to ht_node:PROGRADE - step.
		                      } else {
		                              set ht_node:PROGRADE to ht_node:PROGRADE + step.
                                      }
                              } else {
                                     if current_periapsis > target_periapsis  {
	                                     set ht_node:PROGRADE to ht_node:PROGRADE - step.
                                     } else {
                                             set ht_node:PROGRADE to ht_node:PROGRADE + step.
                                     }
                             }

                             print "ADJUST LOOP: " + loops at (5, 4).

                             print "SHIP PERIAPSIS: " + current_periapsis at (5,7).
                             print "SHIP INCLINATION: " + current_inclination at (5,8).

                             set loops to loops+1.
                             set runmode to 0.
                     }
             }

             clearscreen.

             print "HOHMANN TRANSFER CALCULATION" at (2,0).

             print "TRANSFER NODE ETA: " + ht_node:ETA at (5,5).

             print "SHIP PERIAPSIS: " + current_periapsis at (5,7).
             print "SHIP INCLINATION: " + current_inclination at (5,8).

             print "TARGET PERIAPSIS: " + target_periapsis at (5,10).
             print "TARGET INCLINATION: " + tgt_incl at (5,11).
     }
